Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6851B4796
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 16:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgDVOox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 10:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgDVOox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 10:44:53 -0400
X-Greylist: delayed 77 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Apr 2020 07:44:53 PDT
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1985CC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 07:44:53 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 1001)
        id EEC75C01A; Wed, 22 Apr 2020 16:44:51 +0200 (CEST)
Date:   Wed, 22 Apr 2020 16:44:36 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        dsahern@gmail.com, aclaudi@redhat.com, daniel@iogearbox.net,
        Jamal Hadi Salim <hadi@mojatatu.com>
Subject: Re: [PATCH iproute2 v2 2/2] bpf: Fix mem leak and extraneous free()
 in error path
Message-ID: <20200422144436.GB25914@nautica>
References: <20200422102808.9197-1-jhs@emojatatu.com>
 <20200422102808.9197-3-jhs@emojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200422102808.9197-3-jhs@emojatatu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jamal Hadi Salim wrote on Wed, Apr 22, 2020:
>  	sub = strtok(rem, "/");
>  	while (sub) {
> -		if (strlen(tmp) + strlen(sub) + 2 > PATH_MAX)
> -			return -EINVAL;
> +		if (strlen(tmp) + strlen(sub) + 2 > PATH_MAX) {
> +			ret = -EINVAL;
> +			goto out;
> +		}

Now I'm looking at this we're a bit inconsistent with return values in
this function, other error paths return negative value + errno set,
and this only returns -errno.

Digging a bit into callers it looks like errno is the way to go, so
while you're modifying this it might be worth setting errno to EINVAL as
well here?


Cheers & sorry for nitpicking,
-- 
Dominique
