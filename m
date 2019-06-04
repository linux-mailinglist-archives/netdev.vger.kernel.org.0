Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E2C34739
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 14:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbfFDMq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 08:46:27 -0400
Received: from www62.your-server.de ([213.133.104.62]:50958 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbfFDMq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 08:46:27 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hY8pa-00046h-T5; Tue, 04 Jun 2019 14:46:22 +0200
Received: from [178.197.249.21] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hY8pa-000BRN-Ma; Tue, 04 Jun 2019 14:46:22 +0200
Subject: Re: [PATCH] net: compat: fix msg_controllen overflow in
 scm_detach_fds_compat()
To:     Young Xiao <92siuyang@gmail.com>
References: <1559651505-18137-1-git-send-email-92siuyang@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a4887243-9018-9926-0cbe-8c1ae3b7769e@iogearbox.net>
Date:   Tue, 4 Jun 2019 14:46:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <1559651505-18137-1-git-send-email-92siuyang@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25470/Tue Jun  4 10:01:16 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/04/2019 02:31 PM, Young Xiao wrote:
> There is a missing check between kmsg->msg_controllen and cmlen,
> which can possibly lead to overflow.
> 
> This bug is similar to vulnerability that was fixed in commit 6900317f5eff
> ("net, scm: fix PaX detected msg_controllen overflow in scm_detach_fds").

Back then I mentioned in commit 6900317f5eff:

    In case of MSG_CMSG_COMPAT (scm_detach_fds_compat()), I haven't seen an
    issue in my tests as alignment seems always on 4 byte boundary. Same
    should be in case of native 32 bit, where we end up with 4 byte boundaries
    as well.

Do you have an actual reproducer or is it based on code inspection?

> Signed-off-by: Young Xiao <92siuyang@gmail.com>
> ---
>  net/compat.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/compat.c b/net/compat.c
> index a031bd3..8e74dfb 100644
> --- a/net/compat.c
> +++ b/net/compat.c
> @@ -301,6 +301,8 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
>  			err = put_user(cmlen, &cm->cmsg_len);
>  		if (!err) {
>  			cmlen = CMSG_COMPAT_SPACE(i * sizeof(int));
> +			if (kmsg->msg_controllen < cmlen)
> +				cmlen = kmsg->msg_controllen;
>  			kmsg->msg_control += cmlen;
>  			kmsg->msg_controllen -= cmlen;
>  		}
> 

