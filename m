Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5639B232EB8
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 10:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgG3Iab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 04:30:31 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49968 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728955AbgG3Iaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 04:30:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06U8Tn3v030828;
        Thu, 30 Jul 2020 01:30:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=/VmYl/dzT7inBaJGQ708u7aUdDZTkmoxmKnFyUbDjUE=;
 b=lrMUOS7GNnS1ChRD1aN8iRGTKgEszQOve9wUkZG/JYkkcRtEOilqqGz10LX6ivCo7eoc
 Pm9oJJCucbstxKcIlW+mSqL/70+KiOadfn1yu+W24fI9Sct3w/5H81pGLaJl+Q1bQvBu
 1nbDayG7QLmuh7sTetSQVrqkTWNp3UwPf+UErfvxDqVfwQ4Xe0F299/DB3NDgxe4w2Cf
 xMHVaj71MwcJll2QZ1aF5QwZ2IadZ+dfNfQyBrqw5XeEoHHqg+w6SEKwCojAHOUiK7oQ
 284qGru39RxTXD/dlIeZHL2RMgxLaLWqPD6GVcTezq9zxk+aTYTnrqpZaIOH2eGxSArh +Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3r52qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 01:30:26 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Jul
 2020 01:30:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Jul
 2020 01:30:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Jul 2020 01:30:24 -0700
Received: from [10.193.54.28] (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id A1E6D3F7041;
        Thu, 30 Jul 2020 01:30:21 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH v3 net-next 07/11] qed: use devlink logic to
 report errors
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>
References: <20200729113846.1551-1-irusskikh@marvell.com>
 <20200729113846.1551-8-irusskikh@marvell.com>
 <20200729130833.GE2204@nanopsycho>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <1980e9ac-fd3e-ed41-7583-e4d6ade66e64@marvell.com>
Date:   Thu, 30 Jul 2020 11:30:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101
 Thunderbird/79.0
MIME-Version: 1.0
In-Reply-To: <20200729130833.GE2204@nanopsycho>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_05:2020-07-30,2020-07-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/07/2020 4:08 pm, Jiri Pirko wrote:
> 
> ----------------------------------------------------------------------
> Wed, Jul 29, 2020 at 01:38:42PM CEST, irusskikh@marvell.com wrote:
>> Use devlink_health_report to push error indications.
>> We implement this in qede via callback function to make it possible
>> to reuse the same for other drivers sitting on top of qed in future.

Hi Jiri, thanks for your review, all looks reasonable, fixing now!

Regards,
  Igor
