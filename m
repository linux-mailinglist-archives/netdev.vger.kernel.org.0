Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A3F4BEE82
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 02:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237904AbiBVAod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 19:44:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiBVAoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 19:44:32 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907A8255AF;
        Mon, 21 Feb 2022 16:44:07 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LLlfUn009926;
        Tue, 22 Feb 2022 00:43:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=aWe5S1HI63WoKLakJaS4gzvthnQWlm1CkWGcUtQJgCI=;
 b=kdPSTmjXbxR60mRH69MASyRUgGxDlTF9QRog4b40U4TmWCoc62BZEnMQLaxmj+Usw4OG
 qEFCE1bYXDJnBEFaJvSj8cW5KghChswronA6v81MoYSQ0ipF9qVpoAMl+OBOBMimxkUn
 NorrdwSqGHMLnW/1o6mq5M49QBRxVkwkmKU9umc1uUpDX/yq0BE8DY/pl1YOSuBIN30X
 lfeOXDr71GfBer/ALpTZdSsob9uHemIlTz5anxj5acBrc/+SQVbKsi9E6+yfZX/1R5nD
 1zZWvlNYC1bpUHOuhiMV3HDfHxIJblaxgR6ybtbqcfYr4REwf0JHULqisg4O24UJTjt+ Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecjydjy3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 00:43:52 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21M0hi08016581;
        Tue, 22 Feb 2022 00:43:52 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecjydjy39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 00:43:52 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21M0bAR0006660;
        Tue, 22 Feb 2022 00:43:50 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3eaqtjdn03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 00:43:50 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21M0hmnt51839312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 00:43:48 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0AAD5204E;
        Tue, 22 Feb 2022 00:43:47 +0000 (GMT)
Received: from [9.171.78.41] (unknown [9.171.78.41])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7E9845204F;
        Tue, 22 Feb 2022 00:43:47 +0000 (GMT)
Message-ID: <88a4927eaf3ca385ce9a7406ef23062a39eb1734.camel@linux.ibm.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix implementation-defined
 behavior in sk_lookup test
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Feb 2022 01:43:47 +0100
In-Reply-To: <8ff3f2ff692acaffe9494007a3431c269372f822.camel@linux.ibm.com>
References: <20220221180358.169101-1-jakub@cloudflare.com>
         <8ff3f2ff692acaffe9494007a3431c269372f822.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zB6FT48ce5VDaMY4LEmi-nRvXHsP_jRA
X-Proofpoint-GUID: ciI_eL-YPFVPvIU7DtvDOJmMHcMon5R6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_11,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202220001
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-02-21 at 22:39 +0100, Ilya Leoshkevich wrote:
> On Mon, 2022-02-21 at 19:03 +0100, Jakub Sitnicki wrote:
> > Shifting 16-bit type by 16 bits is implementation-defined for BPF
> > programs.
> > Don't rely on it in case it is causing the test failures we are
> > seeing on
> > s390x z15 target.
> > 
> > Fixes: 2ed0dc5937d3 ("selftests/bpf: Cover 4-byte load from
> > remote_port in bpf_sk_lookup")
> > Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > ---
> > 
> > I don't have a dev env for s390x/z15 set up yet, so can't
> > definitely
> > confirm the fix.
> > That said, it seems worth fixing either way.
> > 
> >  tools/testing/selftests/bpf/progs/test_sk_lookup.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > index bf5b7caefdd0..7d47276a8964 100644
> > --- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > +++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
> > @@ -65,6 +65,7 @@ static const __u32 KEY_SERVER_A = SERVER_A;
> >  static const __u32 KEY_SERVER_B = SERVER_B;
> >  
> >  static const __u16 SRC_PORT = bpf_htons(8008);
> > +static const __u32 SRC_PORT_U32 = bpf_htonl(8008U << 16);
> >  static const __u32 SRC_IP4 = IP4(127, 0, 0, 2);
> >  static const __u32 SRC_IP6[] = IP6(0xfd000000, 0x0, 0x0,
> > 0x00000002);
> >  
> > @@ -421,7 +422,7 @@ int ctx_narrow_access(struct bpf_sk_lookup
> > *ctx)
> >  
> >         /* Load from remote_port field with zero padding (backward
> > compatibility) */
> >         val_u32 = *(__u32 *)&ctx->remote_port;
> > -       if (val_u32 != bpf_htonl(bpf_ntohs(SRC_PORT) << 16))
> > +       if (val_u32 != SRC_PORT_U32)
> >                 return SK_DROP;
> >  
> >         /* Narrow loads from local_port field. Expect DST_PORT. */
> 
> Unfortunately this doesn't help with the s390 problem.
> I'll try to debug this.

I have to admit I have a hard time wrapping my head around the
requirements here.

Based on the pre-9a69e2b385f4 code, do I understand correctly that
for the following input

Port:     0x1f48
SRC_PORT: 0x481f

we expect the following results for different kinds of loads:

Size   Offset  LE      BE
BPF_B  0       0x1f    0
BPF_B  1       0x48    0
BPF_B  2       0       0x48
BPF_B  3       0       0x1f
BPF_H  0       0x481f  0
BPF_H  1       0       0x481f
BPF_W  0       0x481f  0x481f

and this is guaranteed by the struct bpf_sk_lookup ABI? Because then it
looks as if 9a69e2b385f4 breaks it on big-endian as follows:

Size   Offset  BE-9a69e2b385f4
BPF_B  0       0x48
BPF_B  1       0x1f
BPF_B  2       0
BPF_B  3       0
BPF_H  0       0x481f
BPF_H  1       0
BPF_W  0       0x481f0000

Or is the old behavior a bug and this new one is desirable?
9a69e2b385f4 has no Fixes: tag, so I assume that's the former :-(

In which case, would it make sense to fix it by swapping remote_port
and :16 in bpf_sk_lookup on big-endian?

Best regards,
Ilya
