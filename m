Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F453216B5
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 13:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhBVMbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 07:31:22 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13105 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbhBVMat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 07:30:49 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6033a3d10000>; Mon, 22 Feb 2021 04:30:09 -0800
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Feb 2021 12:30:06
 +0000
References: <20210222121030.2109-1-roid@nvidia.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Roi Dayan <roid@nvidia.com>
CC:     <netdev@vger.kernel.org>, Petr Machata <petrm@nvidia.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2-next v2] dcb: Fix compilation warning about
 reallocarray
In-Reply-To: <20210222121030.2109-1-roid@nvidia.com>
Date:   Mon, 22 Feb 2021 13:30:02 +0100
Message-ID: <875z2kl1yt.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613997009; bh=03Xwu1Z+nhoHKia4uriAcwejuA3lZNV2f7fEt+OMr/E=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=PqwWp1ZlnGFauk7snoAcClzxlToCqR8q4/CtYctWCHG1xdorSHvCCkYH/Gbo6HSsn
         N1ltz1PcSDsFmZRjMp0rjhg45LrN0j3Kfh1Qiemd1dbNXsuGXNJ/4GkW6YwD4NAyl9
         SwLH+OQmCU2+GVDheTgIm5PV0yXq+nQ3ZTdwCSx/faFGXjT6kz3YCxWy5k5ilmkis4
         vn35p41cVDkABPDkPfyWjIaMK26mYxh7y4q+Ph+SqoAbdkIghlYaf3ASF5lBvTa/Yh
         5b5E0WpfPS0+N+NKu4zet+Gb+AhXEWav1ujsDNOouSUGgjxmiHIDLSIsknh2jsN2xU
         g5BWW9gsSP19Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Roi Dayan <roid@nvidia.com> writes:

> --- a/dcb/dcb_app.c
> +++ b/dcb/dcb_app.c
> @@ -65,8 +65,7 @@ static void dcb_app_table_fini(struct dcb_app_table *tab)
>  
>  static int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
>  {
> -	struct dcb_app *apps = reallocarray(tab->apps, tab->n_apps + 1,
> -					    sizeof(*tab->apps));
> +	struct dcb_app *apps = realloc(tab->apps, (tab->n_apps + 1) * sizeof(*tab->apps));

reallocarray() checks that count*size does not overflow. But the whole
APP table needs to fit into one attribute, which limits the size to some
64K, so from UAPI direction this will never overflow. From the
command-line direction, size of 'struct app' is 4 bytes, so to overflow
you'd need to stuff in 1G APP entries. I think we don't need to worry
about that.

So this looks good.

Reviewed-by: Petr Machata <petrm@nvidia.com>
