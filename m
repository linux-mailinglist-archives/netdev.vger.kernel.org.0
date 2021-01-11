Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F383A2F1C44
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389497AbhAKRZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:25:05 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45182 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731349AbhAKRZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:25:04 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BHLLCG011638;
        Mon, 11 Jan 2021 09:24:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=fiC4M2MCk7jizdi6N6o2kzRtCi51BUTULVaxfQEMVtM=;
 b=JbhJITgTXcWW1fv13ImAgaqjJAo+MJlS9r8qXw1FpxAbKflYXojnnJYEYucbMV5xq3Sa
 EWiNYzyFs53o1BsxpjasfHFyi9BpmUE8Q/AHMtqxK4W5FEDuo2RFF/c91Y4WxoQgUDUf
 KwcQMMgS+bYJQYCssF0igjNXSOZJ68vo2j91Jlt1LSFE2wMAhHuEsCa15JpbKZwduRNg
 OB39o+u4HO+R68pYXCHbZf9RAJoTpx/I5JPxyd5xwEGP0hL4UHtueRiEg57y3Lr/RFOV
 UFZPA+eM749oMlgqPv7RFc4BkC8KlXU/Mw6gB5oSDZo8JznDYZt076lFM+XEV3YruBIX Nw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsmxbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 09:24:23 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 Jan
 2021 09:24:21 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 11 Jan 2021 09:24:21 -0800
Received: from [10.193.38.82] (unknown [10.193.38.82])
        by maili.marvell.com (Postfix) with ESMTP id 7B81D3F703F;
        Mon, 11 Jan 2021 09:24:20 -0800 (PST)
Subject: Re: Kernel panic on shutdown (qede+bond+bridge) - KASAN:
 use-after-free in netif_skb_features+0x90a/0x9b0
To:     Jakub Kicinski <kuba@kernel.org>,
        Igor Raits <igor.raits@gmail.com>, <mchopra@marvell.com>
CC:     <netdev@vger.kernel.org>
References: <ecd964430ff124469ba48e289cf2e7404fcdc068.camel@gmail.com>
 <20210109125558.0d666227@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <0a79ce08-248f-8b81-21ec-c269b0053e13@marvell.com>
Date:   Mon, 11 Jan 2021 18:24:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <20210109125558.0d666227@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_29:2021-01-11,2021-01-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>> I've been trying out the latest CentOS 8 Stream kernel and found that I
>> get kernel panic
> (https://urldefense.proofpoint.com/v2/url?u=https-3A__bugzilla.redhat.com_
> show-5Fbug.cgi-3Fid-3D1913481&d=DwICAg&c=nKjWec2b6R0mOyPaz7xtfQ&r=3kUjVPjr
> PMvlbd3rzgP63W0eewvCq4D-kzQRqaXHOqU&m=5qgG2X21EmG-uINb8zuD_KKoPReTy65Q4c4K
> -zzCy2s&s=CQwqKQuIm5UJvVJXF2f2LMTagB7PVxG8-IxPqPHkenc&e= )
>> when trying to reboot the server. With debug kernel I've got following:
>>
>> [  531.818434]
>> ==================================================================
>> [  531.818435] BUG: KASAN: use-after-free in
>> netif_skb_features+0x90a/0x9b0
>> [  531.818436] Read of size 8 at addr ffff893c74d54b50 by task systemd-
>> shutdow/1
>> [  531.818436]                            
>> [  531.818437] CPU: 20 PID: 1 Comm: systemd-shutdow Tainted: G        W
>> I      --------- -  - 4.18.0-259.el8.x86_64+debug #1
>> [  531.818438] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380
>> Gen10, BIOS U30 07/16/2020
> 
> Have you managed to find a fix? If not perhaps try an upstream build?
> Unlikely someone here will be willing to help with a RHEL kernel, and
> we can't even access the bug report in bugzilla.

For the record, (thanks Manish Chopra for finding this) here is a fix (I
believe missing in RHEL tree):

commit 2c1644cf6d46a8267d79ed95cb9b563839346562
Author: Feng Sun <loyou85@gmail.com>
Date:   Mon Aug 26 14:46:04 2019 +0800
    net: fix skb use after free in netpoll

Thanks
  Igor
