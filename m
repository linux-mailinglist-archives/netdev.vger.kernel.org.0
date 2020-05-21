Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A257C1DD888
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 22:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbgEUUjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 16:39:03 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46784 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728869AbgEUUjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 16:39:03 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04LKa8uL027327;
        Thu, 21 May 2020 13:38:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=hyp6S4ci9BzJh/ODserLIITVZdvOguPYGI6KNoFSE7A=;
 b=StEyvGzVY2M978S7QJvDkyb7212ICDC2zxWO6gPjYLBrX7L5sv2Iw73wlMULurIKME3E
 GQYF044vxFZ2+NsTgpo1H9PyAHl+PkrPlq3EbVUM/SqcyYuvBJ0aoCC1SkWqe/8t6554
 3yvI+l+KuI5Th8ncGU+/O7wyDXg6vktc6Ze0A6XbC5Ej57u3f9YIGxZMZQ/l4HbJGM2w
 ZFwtKU+6z1tTuu8D2/jk/o/ihdavxPXU+2lhlEsIgTGBvp0sUniLITuDCjvHMyZvmzCP
 7QCayU8kp+zSTNLZK9QWvyG+4cl4eh7kQekVnWvvxHciASGAP5gH5tmXfDDgthSIRCyn ng== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 312fppf4n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 May 2020 13:38:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 21 May
 2020 13:38:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 21 May 2020 13:38:56 -0700
Received: from [10.193.39.5] (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 1A3453F703F;
        Thu, 21 May 2020 13:38:54 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH net-next 03/12] net: atlantic: changes for
 multi-TC support
To:     Jakub Kicinski <kuba@kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Dmitry Bezrukov" <dbezrukov@marvell.com>
References: <20200520134734.2014-1-irusskikh@marvell.com>
 <20200520134734.2014-4-irusskikh@marvell.com>
 <20200520140154.6b6328de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CH2PR18MB323861420A81270EC7207300D3B70@CH2PR18MB3238.namprd18.prod.outlook.com>
 <20200521121156.7f776ef8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <68452ea6-b012-c08c-0c19-9bfce56c6692@marvell.com>
Date:   Thu, 21 May 2020 23:38:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:77.0) Gecko/20100101
 Thunderbird/77.0
MIME-Version: 1.0
In-Reply-To: <20200521121156.7f776ef8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-21_13:2020-05-21,2020-05-21 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> Right now we really aren't sure we can dynamically rearrange
>> resources between QoS and PTP, since disabling/enabling PTP requires
>> a complete HW reconfiguration unfortunately. Even more unfortunate is
>> the fact that we can't change the TC, which is reserved for PTP,
>> because TC2 is hardcoded in firmware.
>>
>> We would prefer to keep things as is for now, if possible. We'll
>> discuss this with HW/FW team(s) and submit a follow-up patch, if we
>> find a way to automatically choose the config.
> 
> Module parameters are very strongly discouraged for networking drivers.
> They also constitute uAPI, and can't be changed, short-term solution
> like that is really far from ideal.

Thanks, Jakub.

Mark, Dmitry, lets try eliminating this parameter. Even if that'll cause some
limitations now - we can think how to dynamically handle these in future.

Regards,
  Igor
