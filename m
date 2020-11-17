Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A9C2B5615
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731811AbgKQBM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:12:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbgKQBM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 20:12:56 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9356D24686;
        Tue, 17 Nov 2020 01:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605575575;
        bh=YA/28z6YHt3X/FyRZ5je9vABev9eox77FVMXcFx7ArA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BfDFH6f+pThMZc9WgUHkRIK+nu28QLijkYeIgO/EN35vptdTKC1QdT9U4Q/2eiqrp
         8b76nL4KaCWKWqy+nLosWfPUHELGLiC+/Jmybntk8eNqNzLek8UiPK+/syZQIcYc9p
         hTe5doK+Yuc3KUDMT9DtMwA86sLrJVsU6jIS55ro=
Date:   Mon, 16 Nov 2020 17:12:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [net v2] net/tls: fix corrupted data in recvmsg
Message-ID: <20201116171254.07b99498@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f88588ce-03c7-74e0-1c43-0213d9133abd@novek.ru>
References: <1605413760-21153-1-git-send-email-vfedorenko@novek.ru>
        <20201116162608.2c54953e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cd2f4bfe-8fff-ddab-d271-08f0917a5b48@novek.ru>
        <20201116165454.5b5dd864@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f88588ce-03c7-74e0-1c43-0213d9133abd@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 00:59:54 +0000 Vadim Fedorenko wrote:
> >>> Sorry I wasn't clear enough, should this be:
> >>>
> >>> 	if (ctx->control != control)
> >>>
> >>> ? Otherwise if we get a control record first and then data record
> >>> the code will collapse them, which isn't correct, right?
> >>>     
> >>>>    				goto recv_end;
> >>>>    		} else {
> >>>>    			break;  
> >> I think you mean when ctx->control is control record and control is
> >> data record.  
> > Yup.
> >  
> >> In this case control message will be decrypted without
> >> zero copy and will be stored in skb for the next recvmsg, but will
> >> not be returned together with data message.  
> > Could you point me to a line which breaks the loop in that case?
> >  
> Sure!
> 
> 		if (!control)
> 			control = tlm->control;
> 		else if (control != tlm->control)
> 			goto recv_end;
> 
> 
> In that case control != tlm->control
> Variable control is set only once and never changes again.

You're right! Applied, thanks!
