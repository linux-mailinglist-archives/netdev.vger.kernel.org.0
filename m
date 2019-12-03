Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7042C10FE46
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 14:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfLCNAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 08:00:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:34812 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725954AbfLCNAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 08:00:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 34583B1EA;
        Tue,  3 Dec 2019 13:00:52 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 70BB4E0125; Tue,  3 Dec 2019 14:00:51 +0100 (CET)
Date:   Tue, 3 Dec 2019 14:00:51 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Maciej Zenczykowski <maze@google.com>,
        Hritik Vijay <hritikxx8@gmail.com>
Subject: Re: [PATCH iproute2] ss: fix end-of-line printing in misc/ss.c
Message-ID: <20191203130051.GD22263@unicorn.suse.cz>
References: <20191127052118.163594-1-brianvv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127052118.163594-1-brianvv@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 09:21:18PM -0800, Brian Vazquez wrote:
> Before commit 5883c6eba517, function field_is_last() was incorrectly
> reporting which column was the last because it was missing COL_PROC
> and by purely coincidence it was correctly printing the end-of-line and
> moving to the first column since the very last field was empty, and
> end-of-line was added for the last non-empty token since it was seen as
> the last field.
> 
> This commits correcrly prints the end-of-line for the last entrien in
> the ss command.
> 
> Tested:
> diff <(./ss.old -nltp) <(misc/ss -nltp)
> 38c38
> < LISTEN    0   128     [::1]:35417   [::]:*   users:(("foo",pid=65254,fd=116))
> \ No newline at end of file
> ---
> > LISTEN    0   128     [::1]:35417   [::]:*   users:(("foo",pid=65254,fd=116))
> 
> Cc: Hritik Vijay <hritikxx8@gmail.com>
> Fixes: 5883c6eba517 ("ss: show header for --processes/-p")
> Signed-off-by: Brian Vazquez <brianvv@google.com>

Tested-by: Michal Kubecek <mkubecek@suse.cz>

> ---
>  misc/ss.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/misc/ss.c b/misc/ss.c
> index c58e5c4d..95f1d37a 100644
> --- a/misc/ss.c
> +++ b/misc/ss.c
> @@ -1290,6 +1290,11 @@ static void render(void)
>  
>  		token = buf_token_next(token);
>  	}
> +	/* Deal with final end-of-line when the last non-empty field printed
> +	 * is not the last field.
> +	 */
> +	if (line_started)
> +		printf("\n");
>  
>  	buf_free_all();
>  	current_field = columns;
> -- 
> 2.24.0.432.g9d3f5f5b63-goog
> 
