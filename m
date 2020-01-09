Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02BA71363D4
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 00:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgAIX2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 18:28:37 -0500
Received: from smtp8.emailarray.com ([65.39.216.67]:52948 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgAIX2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 18:28:37 -0500
Received: (qmail 46757 invoked by uid 89); 9 Jan 2020 23:28:34 -0000
Received: from unknown (HELO ?172.20.55.144?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4xMzY=) (POLARISLOCAL)  
  by smtp8.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 9 Jan 2020 23:28:34 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "John Fastabend" <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [bpf PATCH 9/9] bpf: sockmap/tls, fix pop data with SK_DROP
 return code
Date:   Thu, 09 Jan 2020 15:28:31 -0800
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <62927807-669A-4917-8A88-DCFAC6A31FA5@flugsvamp.com>
In-Reply-To: <157851818932.1732.14521897338802839226.stgit@ubuntu3-kvm2>
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
 <157851818932.1732.14521897338802839226.stgit@ubuntu3-kvm2>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8 Jan 2020, at 13:16, John Fastabend wrote:

> When user returns SK_DROP we need to reset the number of copied bytes
> to indicate to the user the bytes were dropped and not sent. If we
> don't reset the copied arg sendmsg will return as if those bytes were
> copied giving the user a positive return value.
>
> This works as expected today except in the case where the user also
> pops bytes. In the pop case the sg.size is reduced but we don't correctly
> account for this when copied bytes is reset. The popped bytes are not
> accounted for and we return a small positive value potentially confusing
> the user.
>
> The reason this happens is due to a typo where we do the wrong comparison
> when accounting for pop bytes. In this fix notice the if/else is not
> needed and that we have a similar problem if we push data except its not
> visible to the user because if delta is larger the sg.size we return a
> negative value so it appears as an error regardless.
>
> Fixes: 7246d8ed4dcce ("bpf: helper to pop data from messages")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
