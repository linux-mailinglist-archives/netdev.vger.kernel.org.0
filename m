Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4803327E3E5
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 10:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgI3IhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 04:37:08 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41424 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725823AbgI3IhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 04:37:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08U8YlZS018582;
        Wed, 30 Sep 2020 01:37:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=gayqKztZNVuu83C3SntEEysrCXmeeyra8qe9UAD2Yms=;
 b=EQChevf9Rh1aESKNWBmdAqM1Tglj7LBp+/oNsU1wd3zgQxgLTX8DWfxI+vVTcDqdBlZt
 Mz0GZGCKjFqM4lCNuquKYEH09E020euQJTubqac7bhN0LIYWgiq+vEK7ArACUp+CW2kZ
 Tiycz0Rm7Ys5hsZe4QqTJcwNoPDSC5+M2QNZDeAwFL0u7851ZShaGLv1eUdIMapYaHee
 FMAV89xXs6fWn+xR2hQpOgJXhfTzSGn0YZUisUqK2lrP64AnmdDIhM2FfyuvSV1PM4H2
 1VL3ItuFz/HWHmPb4eo+Pi2gxflKGX2OKEh34sW+LW1mRePguXA3q7RsBA5fC0or6gLK Jg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teemfmc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 30 Sep 2020 01:37:04 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 30 Sep
 2020 01:37:03 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 30 Sep
 2020 01:37:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 30 Sep 2020 01:37:03 -0700
Received: from [10.193.39.7] (NN-LT0019.marvell.com [10.193.39.7])
        by maili.marvell.com (Postfix) with ESMTP id AA8833F704A;
        Wed, 30 Sep 2020 01:37:01 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: atlantic: implement media detect
 feature via phy tunables
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
References: <20200929161307.542-1-irusskikh@marvell.com>
 <20200929161307.542-4-irusskikh@marvell.com>
 <20200929171815.GD3996795@lunn.ch>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <b43fb357-3fd1-c1a5-e2ff-894eb11c2bbb@marvell.com>
Date:   Wed, 30 Sep 2020 11:37:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:82.0) Gecko/20100101
 Thunderbird/82.0
MIME-Version: 1.0
In-Reply-To: <20200929171815.GD3996795@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_05:2020-09-29,2020-09-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>  	switch (tuna->id) {
>> +	case ETHTOOL_PHY_EDPD: {
>> +		const u16 *val = data;
>> +
>> +		/* msecs plays no role - configuration is always fixed in
> PHY */
>> +		aq_nic->aq_nic_cfg.is_media_detect = *val ? 1 : 0;
> 
> This is the wrong usage of the API:
> 
> include/uapi/linux/ethtool.h:
> 
> * The interval units for TX wake-up are in milliseconds, since this should
>  * cover a reasonable range of intervals:
>  *  - from 1 millisecond, which does not sound like much of a power-saver
>  *  - to ~65 seconds which is quite a lot to wait for a link to come up
> when
>  *    plugging a cable
>  */
> 
> I guess your PHY is not hard coded to 1 millisecond? Please return the
> real value. And the set call should really only allow 0, or the value
> the PHY is using.

The problem here is that FW interface only allows us to switch this mode on or
off. We can't control the interval value for this device.
Thus, we only can enable it, or disable. Basically ignoring the interval value.

Igor
