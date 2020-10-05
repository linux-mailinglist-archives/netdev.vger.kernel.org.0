Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE83284307
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 01:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgJEXo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 19:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgJEXo6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 19:44:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5EB22075A;
        Mon,  5 Oct 2020 23:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601941497;
        bh=l7xTFPxR++3YGNhG0tMTgJvzPfm+eWJ3YyQc0gFtNjo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OUuAp3K5tBPyPIO2HsEyceD5LU1rE71eaTlqLPx19tyznGBQtRAN4LLxR6L09Tg+H
         TGRFVC4yE56gKfTYCdH00/XD2LFfQ0WjfldMfPmc7tA+lrB+sJjCm8TQczAEi6tBGj
         s77aCzE67/6UE1cUelssk8V4KEQelp3x0yBeCfGk=
Date:   Mon, 5 Oct 2020 16:44:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net v2] net/tls: sendfile fails with ktls offload
Message-ID: <20201005164455.1f9c8c99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201005184313.3887-1-rohitm@chelsio.com>
References: <20201005184313.3887-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Oct 2020 00:13:13 +0530 Rohit Maheshwari wrote:
> At first when sendpage gets called, if there is more data, 'more' in
> tls_push_data() gets set which later sets pending_open_record_frags, but
> when there is no more data in file left, and last time tls_push_data()
> gets called, pending_open_record_frags doesn't get reset. And later when
> 2 bytes of encrypted alert comes as sendmsg, it first checks for
> pending_open_record_frags, and since this is set, it creates a record with
> 0 data bytes to encrypt, meaning record length is prepend_size + tag_size
> only, which causes problem.
>  We should set/reset pending_open_record_frags based on more bit.
> 
> Also incase if tls_do_allocation() fails, and if record len is only
> prepend_size, then destroy the record.
> 
> v1->v2:
> - handle tls_do_allocation() failure handling.
> 
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> ---
>  net/tls/tls_device.c | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index b74e2741f74f..f3efd53e31cf 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -463,17 +463,16 @@ static int tls_push_data(struct sock *sk,
>  			if (!record)
>  				break;
>  handle_error:
> -			if (record_type != TLS_RECORD_TYPE_DATA) {
> -				/* avoid sending partial
> -				 * record with type !=
> -				 * application_data
> -				 */
> -				size = orig_size;
> -				destroy_record(record);
> -				ctx->open_record = NULL;
> -			} else if (record->len > prot->prepend_size) {
> +			/* avoid sending partial record with type !=
> +			 * application_data
> +			 */
> +			if (record_type == TLS_RECORD_TYPE_DATA &&
> +			    record->len > prot->prepend_size)
>  				goto last_record;
> -			}
> +
> +			size = orig_size;
> +			destroy_record(record);
> +			ctx->open_record = NULL;

Yet, this still does not update pending_open_record_frags...

>  			break;
>  		}
> @@ -492,11 +491,11 @@ static int tls_push_data(struct sock *sk,
>  		if (!size) {
>  last_record:
>  			tls_push_record_flags = flags;
> -			if (more) {
> -				tls_ctx->pending_open_record_frags =
> -						!!record->num_frags;
> +			/* set/clear pending_open_record_frags based on more */
> +			tls_ctx->pending_open_record_frags = !!more;
> +
> +			if (more)
>  				break;
> -			}
>  
>  			done = true;
>  		}

Maybe I'm misunderstanding what you're fixing but I think you should
just do this:

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b74e2741f74f..674964d5684b 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -418,7 +418,6 @@ static int tls_push_data(struct sock *sk,
        struct tls_context *tls_ctx = tls_get_ctx(sk);
        struct tls_prot_info *prot = &tls_ctx->prot_info;
        struct tls_offload_context_tx *ctx = tls_offload_ctx_tx(tls_ctx);
-       int more = flags & (MSG_SENDPAGE_NOTLAST | MSG_MORE);
        struct tls_record_info *record = ctx->open_record;
        int tls_push_record_flags;
        struct page_frag *pfrag;
@@ -426,6 +425,7 @@ static int tls_push_data(struct sock *sk,
        u32 max_open_record_len;
        int copy, rc = 0;
        bool done = false;
+       bool more = false;
        long timeo;
 
        if (flags &
@@ -492,9 +492,8 @@ static int tls_push_data(struct sock *sk,
                if (!size) {
 last_record:
                        tls_push_record_flags = flags;
-                       if (more) {
-                               tls_ctx->pending_open_record_frags =
-                                               !!record->num_frags;
+                       if (flags & (MSG_SENDPAGE_NOTLAST | MSG_MORE)) {
+                               more = true;
                                break;
                        }
 
@@ -526,6 +525,8 @@ static int tls_push_data(struct sock *sk,
                }
        } while (!done);
 
+       tls_ctx->pending_open_record_frags = more;
+
        if (orig_size - size > 0)
                rc = orig_size - size;
 
