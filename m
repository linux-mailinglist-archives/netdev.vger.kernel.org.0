Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5FC419328
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 13:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbhI0LfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 07:35:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45416 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233948AbhI0LfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 07:35:14 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18RBQov0027164;
        Mon, 27 Sep 2021 07:33:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Zh4ocPd5zq01wbH2VJDNCfT88s0EYVFeCQkN48p09Rc=;
 b=HFxbLZtALlzLcIV513Gw+sxVwvyBy56n2YzyuwSn5PhVx+r78j+XpSTou4uCQxcVZnoE
 ORBmrmCvRSJjDV+Ccv2/aAl0E0LKSqjtC7pEVYkcfhGs2gARhJrtNmpcMZLACj1l3H9e
 wiOzzrnbeakRimBQKGiZG/vgljuMDfDH40vFu6QUIrDqxXQm0raGWFyPpAM+xNskL32L
 cit9eG4DTS9wNpPPnwq/OiGUy3QfNwVJL1bvIFM7kz7dvrsv4WGOaJ2SSB2cnUlgVe2w
 xizeUAt1Oo/0G6wIHGgXQzOY2Vejlh581H5hmUOcXLZvcVfbDeJx89csV2wfHViBPvSe YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bagv81unu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 07:33:18 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18RBQVOH012751;
        Mon, 27 Sep 2021 07:33:18 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bagv81umx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 07:33:17 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18RBVJoX026969;
        Mon, 27 Sep 2021 11:33:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3b9ud9b7y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 11:33:15 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18RBXBwa2294488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 11:33:11 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EF8442094;
        Mon, 27 Sep 2021 11:33:11 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7804D4205C;
        Mon, 27 Sep 2021 11:33:10 +0000 (GMT)
Received: from sig-9-145-45-184.uk.ibm.com (unknown [9.145.45.184])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Sep 2021 11:33:10 +0000 (GMT)
Message-ID: <e9665315bc2f244d50d026863476e72e3d9b8067.camel@linux.ibm.com>
Subject: Re: [PATCH RESEND bpf] bpf, s390: Fix potential memory leak about
 jit_data
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
Date:   Mon, 27 Sep 2021 13:33:10 +0200
In-Reply-To: <1632726374-7154-1-git-send-email-yangtiezhu@loongson.cn>
References: <1632726374-7154-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: giYAHGJqTgpQ3DQJ2HWE-ISyvY6pZDkS
X-Proofpoint-ORIG-GUID: hgcrE1P2X7C_h_hUHBTq5OFZJdaEnIUq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_04,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=944 malwarescore=0 phishscore=0 adultscore=0
 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270079
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-09-27 at 15:06 +0800, Tiezhu Yang wrote:
> Make sure to free jit_data through kfree() in the error path.
> 
> Fixes: 1c8f9b91c456 ("bpf: s390: add JIT support for multi-function
> programs")
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
> 
> RESEND due to the following reason:
> [Can not connect to recipient's server because of unstable
> network or firewall filter. rcpt handle timeout, last handle
> info: Can not connect to vger.kernel.org]
> 
>  arch/s390/net/bpf_jit_comp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Nice catch, thanks!

Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>

