Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0031C1CA587
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 10:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgEHIAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 04:00:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36642 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbgEHIAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 04:00:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0487p98J021513;
        Fri, 8 May 2020 01:00:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=0JOSp3O9OivyzD1QuluLkQBX4z8mjZPuRutwsVwPaVA=;
 b=S7MasBn/gIgbxyl+fIS0OS6ezj4KDSU7X6TBS8AIVlraALHyP01ANgA0Meu8YtJECqUY
 VjjVA7CyQoijRFmCtRxjaQauqyv+klv3kGte64dFO84OhZ+TbsGMHBand1wj63XU/Wfm
 lgWrVvbezJ17Eqw/JOGlXtuWeIZWrY5rLzgdOEJbG8A9Fl2gyxpvcv2qE3tgzum7C/NS
 nmy6Cjbo13JRTH0WqA8scrry764BqXNpSXsoggPRVHsYmkJwidox8i0FOoEEd6gkppla
 ByvRts55TUE/qbPD5MxzSSfc8xIjxbzg9IDCv7PU5xbyrDiJrHAM6R+Ch+MgIvK0qZhR Ww== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30vtdv9wng-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 01:00:26 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 01:00:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 01:00:24 -0700
Received: from [10.193.46.2] (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id D64B83F703F;
        Fri,  8 May 2020 01:00:22 -0700 (PDT)
Subject: Re: [PATCH net-next 06/12] net: qed: gather debug data on hw errors
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Ariel Elior" <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Denis Bolotin" <dbolotin@marvell.com>
References: <cover.1588758463.git.irusskikh@marvell.com>
 <a380a45a885034c9b19cd1fe786854e8a65a8088.1588758463.git.irusskikh@marvell.com>
 <20200506123120.02d4c04f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <01a9d7a5-3f8c-1799-cd0e-bb2dc8c7f177@marvell.com>
Date:   Fri, 8 May 2020 11:00:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101
 Thunderbird/76.0
MIME-Version: 1.0
In-Reply-To: <20200506123120.02d4c04f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_08:2020-05-07,2020-05-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Wed, 6 May 2020 14:33:08 +0300 Igor Russkikh wrote:
>> To implement debug dump retrieval on a live system we add callbacks to
>> collect the same data which is collected now during manual `ethtool -d`
>> call.
>>
>> But we instead collect the dump immediately at the moment bad thing
>> happens, and save it for later retrieval by the same `ethtool -d`.
>>
>> To have ability to track this event, we add kobject uevent trigger,
>> so udev event handler script could be used to automatically collect
> dumps.
> 
> No way. Please use devlink health. Instead of magic ethtool dumps and
> custom udev.
> 

Hi Jakub,

Thanks for the suggestion. I've looked into devlink health infrastructure, but
what's warned me is that our device health dumps are huge (~3Mb). I'm not sure
if health dump infrastructure is designed to push that amounts of data.

I'll check if that's feasible.

Thanks,
  Igor
