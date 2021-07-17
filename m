Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304A13CC477
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 18:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbhGQQg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 12:36:26 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:38813
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S229581AbhGQQgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 12:36:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=FKpHiS169x9azDRzGN9bbvMcEmln4K0mzgvH
        HsRjbx4=; b=HIh/zbXcz9z9v7WoTLdCl50YpXzMXjU39W1jSiucLnf+xz0kDuVi
        StIfKL0cxbfuffF0MCud8865tXrwj2d3Y6PIYo63qm/Qt5TCjQUYCaA2MdO4U8Ny
        ndaefCap27761AynrgcwSJSn3fdX9IJL6rqxy/Js1/iCuzVW6ghS4jg=
Received: by ajax-webmail-app2 (Coremail) ; Sun, 18 Jul 2021 00:32:31 +0800
 (GMT+08:00)
X-Originating-IP: [39.144.105.157]
Date:   Sun, 18 Jul 2021 00:32:31 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Xiyu Yang" <xiyuyang19@fudan.edu.cn>
To:     "Trond Myklebust" <trondmy@hammerspace.com>
Cc:     "tanxin.ctf@gmail.com" <tanxin.ctf@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kolga@netapp.com" <kolga@netapp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "yuanxzhang@fudan.edu.cn" <yuanxzhang@fudan.edu.cn>
Subject: Re: Re: [PATCH] SUNRPC: Convert from atomic_t to refcount_t on
 rpc_clnt->cl_count
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20200917(8294e55f) Copyright (c) 2002-2021 www.mailtech.cn fudan.edu.cn
In-Reply-To: <1f12b3569565fa8590b45cc2fbe7c176ca7c5184.camel@hammerspace.com>
References: <1626517112-42831-1-git-send-email-xiyuyang19@fudan.edu.cn>
 <1f12b3569565fa8590b45cc2fbe7c176ca7c5184.camel@hammerspace.com>
X-SendMailWithSms: false
Content-Transfer-Encoding: 7bit
X-CM-CTRLDATA: 28cyeGZvb3Rlcl90eHQ9MTU4OToxMA==
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <78709d5e.49a9.17ab54fead8.Coremail.xiyuyang19@fudan.edu.cn>
X-Coremail-Locale: en_US
X-CM-TRANSID: XQUFCgBnbvYfBvNgEebaBA--.55915W
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/1tbiARAFAVKp4xMhKAAAsX
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Sorry, I'm not sure why you need to bump a zero refcount in a normal situation. But maybe we can use refcount_inc_not_zero() API in rpc_free_auth() instead?

> -----Original Messages-----
> From: "Trond Myklebust" <trondmy@hammerspace.com>
> Sent Time: 2021-07-17 22:43:26 (Saturday)
> To: "tanxin.ctf@gmail.com" <tanxin.ctf@gmail.com>, "xiyuyang19@fudan.edu.cn" <xiyuyang19@fudan.edu.cn>, "davem@davemloft.net" <davem@davemloft.net>, "chuck.lever@oracle.com" <chuck.lever@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kolga@netapp.com" <kolga@netapp.com>, "kuba@kernel.org" <kuba@kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "bfields@fieldses.org" <bfields@fieldses.org>, "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
> Cc: "yuanxzhang@fudan.edu.cn" <yuanxzhang@fudan.edu.cn>
> Subject: Re: [PATCH] SUNRPC: Convert from atomic_t to refcount_t on rpc_clnt->cl_count
> 
> On Sat, 2021-07-17 at 18:18 +0800, Xiyu Yang wrote:
> > refcount_t type and corresponding API can protect refcounters from
> > accidental underflow and overflow and further use-after-free
> > situations.
> > 
> 
> Have you tested this patch? As far as I remember, the reason why we
> never converted is that refcount_inc() gets upset and WARNs when you
> bump a zero refcount, like we do very much on purpose in
> rpc_free_auth(). Is that no longer the case?
> 
> 
> -- 
> Trond Myklebust
> Linux NFS client maintainer, Hammerspace
> trond.myklebust@hammerspace.com
> 
> 






