Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679392A4BAE
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 17:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgKCQgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 11:36:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45260 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728206AbgKCQgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 11:36:47 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3GWTAd024649;
        Tue, 3 Nov 2020 11:36:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=D6wUaqBtSMUldA2srycpKni9JRf4u/nyapDxt2Q2JMw=;
 b=QfMMaSEDId9IS60AB0eNeaTCDJB5PPcKhuPFHAGyPYAps8eKIKL1A7NhQoD4WU3ovucI
 UwZ4CTzREzpQRlA9iUDtA0lx4i8WaiF+oiIxmsyrISyOlUORKv3edNutIslOfjdDD91C
 sRCO8oVIORVFsyWG2qsO0QGTg5efR9gXT1DdM2nASYWmfQ89rOXyWSJ2a0BbtImeODGa
 5ZScR5mxNr4aW31wIiKZWOpH4wclyrOQnhrU2mmW8HqQZb/KXPSNOzE6cYe2ofcaXEW5
 Wel1OQ3OwvhyugFrH1u03Fy1jKXPgukrTvQ/uXQPjQOPLhPDlh9L9i5VnHwqpApfcicj hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34k14uh40p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 11:36:37 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A3GXLkb031068;
        Tue, 3 Nov 2020 11:36:37 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34k14uh3yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 11:36:37 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A3GWW2D001069;
        Tue, 3 Nov 2020 16:36:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 34h0f6srtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 16:36:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A3GaVcL61538676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Nov 2020 16:36:31 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA63011C06C;
        Tue,  3 Nov 2020 16:36:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16DD111C06E;
        Tue,  3 Nov 2020 16:36:31 +0000 (GMT)
Received: from [9.145.53.13] (unknown [9.145.53.13])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Nov 2020 16:36:30 +0000 (GMT)
Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
To:     Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, james.jurack@ametek.com
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
 <20201029081057.8506-1-claudiu.manoil@nxp.com>
 <20201103161319.wisvmjbdqhju6vyh@skbuf>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <2b0606ef-71d2-cc85-98db-1e16cc63c9d2@linux.ibm.com>
Date:   Tue, 3 Nov 2020 18:36:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201103161319.wisvmjbdqhju6vyh@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_08:2020-11-03,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 suspectscore=0 clxscore=1011 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030108
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.11.20 18:13, Vladimir Oltean wrote:
> On Thu, Oct 29, 2020 at 10:10:56AM +0200, Claudiu Manoil wrote:
>> When PTP timestamping is enabled on Tx, the controller
>> inserts the Tx timestamp at the beginning of the frame
>> buffer, between SFD and the L2 frame header.  This means
>> that the skb provided by the stack is required to have
>> enough headroom otherwise a new skb needs to be created
>> by the driver to accommodate the timestamp inserted by h/w.
>> Up until now the driver was relying on skb_realloc_headroom()
>> to create new skbs to accommodate PTP frames.  Turns out that
>> this method is not reliable in this context at least, as
>> skb_realloc_headroom() for PTP frames can cause random crashes,
>> mostly in subsequent skb_*() calls, when multiple concurrent
>> TCP streams are run at the same time with the PTP flow
>> on the same device (as seen in James' report).  I also noticed
>> that when the system is loaded by sending multiple TCP streams,
>> the driver receives cloned skbs in large numbers.
>> skb_cow_head() instead proves to be stable in this scenario,
>> and not only handles cloned skbs too but it's also more efficient
>> and widely used in other drivers.
>> The commit introducing skb_realloc_headroom in the driver
>> goes back to 2009, commit 93c1285c5d92
>> ("gianfar: reallocate skb when headroom is not enough for fcb").
>> For practical purposes I'm referencing a newer commit (from 2012)
>> that brings the code to its current structure (and fixes the PTP
>> case).
>>
>> Fixes: 9c4886e5e63b ("gianfar: Fix invalid TX frames returned on error queue when time stamping")
>> Reported-by: James Jurack <james.jurack@ametek.com>
>> Suggested-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
>> ---
> 
> Still crashes for me:
> 

Given the various skb modifications in its xmit path, I wonder why
gianfar doesn't clear IFF_TX_SKB_SHARING.
