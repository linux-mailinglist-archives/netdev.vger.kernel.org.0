Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BA2644A98
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 18:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiLFRrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 12:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiLFRry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 12:47:54 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16D0CC2;
        Tue,  6 Dec 2022 09:47:51 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2B6FdCfO011293;
        Tue, 6 Dec 2022 09:47:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=4l0k6NqtstJeyNjxilSrfg1ujsEg5J/m5R7P9h8QXVs=;
 b=YNC9QUth0hDp30Rb1q1mraDDX2U5IFS/ajxGROkb84FUncy5WGiPArkWebCcdEyknlXv
 ZjHaeK6cBLdy/zcIJBJ9BuB+phY9Ef7U9aTGUMRhmQrEI+u5VQdZlc9JcMTwTHHkxNb9
 Bzq3jeAkntLtVCBKFE3gqDDgs051BWvj2OfkRrZIrSWS7rTiXLJ19v/33JL1XiSiSmNz
 9j2B/KAeFIpzDBJYd8mZYFihNqAzp3i6Q9+4Azy0E3fI+kMgOM1AuuhIQMYL+7dsGGvr
 EFTDH9TLsbKmG3qs/F6/kcln59klT2DdogLoS25bNqksRrxXuradWDK3GsSpuvfIt8Um bg== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
        by m0001303.ppops.net (PPS) with ESMTPS id 3m9g8cb2r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 09:47:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fBEzN/chYMPfOqsxPOBM5qhr2HkOB95bd4fjchXoZvh6aoBrm6kWpRQMRM9A1KPmfku3QA82IepFkEG4v2rPaFE059pqtaowF/S4TkXiqWhHiZwJ4a7zCqN1cgzw6ACTK8RdfA9Ug6uHxqZe0x1tkM51urXymwmHqBhTJH3KNGZ/cviDZT14DQB4t/qouzTtze+qvTFvzm2J4nYw5FWd2NMnn3+bsJjzYd+4/mMx3UjaQ90Rr1lazucCCe/xTBxTu/aFpHcbk885jJByQWuhFccGcwidOvKr+d5wTS2PSjlHf9mK6kwhaw0dHHP0elDJCuLbh/SlKMrpi3uMh39uQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4l0k6NqtstJeyNjxilSrfg1ujsEg5J/m5R7P9h8QXVs=;
 b=i7KxlzSU+l7M4wt8h4C6VLBIDiNADmMVeF6RX2/Gg5lPgQo0wdUfpcwaNCsVHmMUF+76Oc3HrbCZSbOgPZsdjnCUQGA95FLNnbNlO9s8yGvdMtPvF9iBA2aOllMArBFHYsBqaWoFRAsYclJV3Yix4O/XRJjvDNnhI8gZPvVD5+k9FyI0Pee++ucLfY0/6+hU3KSDMlVz0+nxcK4ovs/Y8ZrqqaGo9FTrIWZ8dQ9vord3OViQ8ULOWKqknxPpAAvDXHYYPGOgQ64YL+iuF0pOfFg6MkxhnaeuUMIrqCzJ3WwNs4XrUFsrmJbsqsCDeFkEuUozIdvFePySaP02jNzeZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB2698.namprd15.prod.outlook.com (2603:10b6:5:1af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 6 Dec
 2022 17:47:24 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf%7]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 17:47:24 +0000
Message-ID: <d26622c6-d51e-e280-6c8a-38c893c49446@meta.com>
Date:   Tue, 6 Dec 2022 09:47:21 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH bpf] bpf: Proper R0 zero-extension for BPF_CALL
 instructions
Content-Language: en-US
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Brendan Jackman <jackmanb@google.com>
References: <20221202103620.1915679-1-bjorn@kernel.org>
 <3b77aa12a864ab2db081e99aec1bfad78e3b9b51.camel@linux.ibm.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <3b77aa12a864ab2db081e99aec1bfad78e3b9b51.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR07CA0040.namprd07.prod.outlook.com
 (2603:10b6:a03:60::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|DM6PR15MB2698:EE_
X-MS-Office365-Filtering-Correlation-Id: 4332736f-e180-4ef0-eeb6-08dad7b1ef02
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /JP8U6QJGG8VMbsBN8weldJO4axI74+73f32sqN32GKTwb443clBsBqYvhBNh4QJvncdWbm9Poyi+FW9B5zWzUQKT27h+M4l8SyxvNOyjeh4hDoLk9T+KrZRictetNBuAXxV8dxqNTlFC9iB0KRfGZCeVeBtL4IBCwrmNO28dDxnI7i1BuKW6X1oQ8nFzvYSgGO6mKTlFcho4dhLPUXI7JW1TJD4kTaYZ488jEBo7g4tlEM04enm/5/v1RkElSka7PnQyiwPjmN/3uEbBD5MwcFfRwLkM9ReSNLBQTcdKyWrg149X+Ubmo4OfzEnyl/AhITP+OH7KGBhXxwikBasyHqY86yd9MjEdgJf7zVruxIzK55UM7/WMxstYmBX7SSGY1o0HGOy8g71vIhSH526sQJQVjpAACRLjJKG0bR9Zu2LoMrs9MEf+oENOzXVki8Hj/i5sBRSBbjJxmH6r0A2X5aE4GdIALbsE26olWOMzKG+CfVfD5oOk4pPslQhNzejLY9v+kEobPNMUjg98GaaS2J4ttYNSp31AOQVpVbZYSc1zSIt7KYd7g9v4cQcHUbYGzXzbnzFrN7KCMKoWMN1ip+syI/POOpHQRjlTndPX00gPOxw/RwU2vSStZOc1RFQ8qLOWMmyxUsiqexyJ156K1i6aaGN0RDfH5vp2rCiEFQBYpsZUn56T/0M9lmSU5P0bTjz2uSEo2aqNbApYZ4OWJonQZvZFuazZDEfqy1nIkzHjraxM1WwbbetzxUqVGAn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(451199015)(6666004)(478600001)(6506007)(31686004)(53546011)(66946007)(54906003)(6512007)(110136005)(966005)(6486002)(8676002)(66556008)(316002)(4326008)(66899015)(66476007)(8936002)(31696002)(41300700001)(5660300002)(66574015)(86362001)(2616005)(186003)(83380400001)(2906002)(36756003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVlVWEdIVlZZQlN3NlQ3cHFtSk5Zb3FYSk56akxsNzFWV203M2hRQ1lyK0N4?=
 =?utf-8?B?bDRYQllaQ2FJcjViR1k1ZzBzVi9peUJhVUZjcTA1SFpBaEx5WkloVVVEbjQ2?=
 =?utf-8?B?Z0hYcHZDMmEyQldsTlpGQkdFTDE4UlRWazBCNEZ3UlNkakdTWXV3RHdmSm1J?=
 =?utf-8?B?cXpVSkg3Z1Yrbk9DYkNjcUFIZUdicHBhN1loZUxIejNBTzFVUSsxRnV4VzlG?=
 =?utf-8?B?a2lud1htK1JPN0JTNk44L3NjS3NRaVBQNVBHMDJsVTdaVXRjYnFnRytjQ1A3?=
 =?utf-8?B?Y05uMFpsUEREdGR0c0ZTWis3Nld4VTMrRENya3I0TGVQRjgrSU15ZE45N1F5?=
 =?utf-8?B?aWhyeUJ6OEVtNTAwckxqbHB2MXVvUEFjNVMvYnlSVGtMSDFZN1pnSHFVZm5M?=
 =?utf-8?B?UWduanZZdDdJVk5WUXpkejJpV2JUWUUwUEt5N2JNWmE3bU84dlBibGc1Zm9s?=
 =?utf-8?B?NnJQcWc4TWp4akJwdEN5RFBFUjN6Z2FGWGpjVUloOU9VQ2NtUTVPWEJrOW45?=
 =?utf-8?B?bFM2Qno2aXN0MWNjRmZqbDFVWHdvTHhFd2VieFUzdFV5QzZHMVpjblVVSXNr?=
 =?utf-8?B?cm1UZVJzbmY2YzBjcFZMaUE4UmZnVnJBNVZwN2tSNU93R2N6MmJGZTRrTUta?=
 =?utf-8?B?c2hVU2RkSjJ1Z2grYjJxMVRPV3R6N3ptTlhReXVQZTBqamVjNTJBV285R01r?=
 =?utf-8?B?RXNHc3R1cXZBN0JJaFJHRFFYdjh5YllWQm5XVktoOTZiQ01LcFh4QmZiM2hZ?=
 =?utf-8?B?YjNjVUZxWUNSUHZBQi90cExhU250S0lGMUs2d2tacGYybml3bGduZFhzNjk5?=
 =?utf-8?B?Wlg2anJ6Ni9TYU5JMngrMStVck1TZDUwckNHcUtXbkJkSnFhdTFLbnZ5ZjBY?=
 =?utf-8?B?NExZNlVXQXJrcm9BY2xOWG05UTUzbXY2cmJNZit4dGFMeFZiRzdpeDZnNjMv?=
 =?utf-8?B?UTk5SEVHOG52Q3JQODV6Q0x3RHlHdkhhS3piV25MbFVMK1Z3UWZVUVRYRDUz?=
 =?utf-8?B?RHVWTkJtVUd1Nk4rOHhabFZ1QXF2N21GMnZJbnVRTzZDYitYYXM0dHhiN0tr?=
 =?utf-8?B?UHFScDVBZWpTWnV2S2VuTEQ2N3VJQlJJRmRRUGNjUUxyM1hqa003ZG9zWHR0?=
 =?utf-8?B?TEY0YVJUZitEYVhjWmxnV0JxYU52aHlZY2tnVzE4WFBKaGJhWXJDWXM4WUpz?=
 =?utf-8?B?WEJIVE9YOFFoU2ZHZG1oMFNySDI5R3NLMHBlTjZmUldleFpNTktnUmx1NE1T?=
 =?utf-8?B?QVVrNXMxa1JicmdNbW85dU84cC9nNmxyQnE1SzNPQUpnckF4TDRtaFpoUUR0?=
 =?utf-8?B?aVJ2elVhU3RtRlZ5SUJkN2NtTEUvTXJJeDlZTlBlZlk3SDVvb09ZT20vVThn?=
 =?utf-8?B?TVo1ajE1ZTROeThOdWNMNitsUXZUMUhJR2FKRDAwOG1pckZ4MFlvTll4WTZQ?=
 =?utf-8?B?TnZDa1hMcTBacnJOZnc5WHRydERpTmJPUVdIZ2wvdk9odHMyYWFYMWFzMGJz?=
 =?utf-8?B?N1dhRVc2bFhhb0dlVTVveXh2SXkvVkRGL2pSYmZVaURDS01uV3o3eURCYVgr?=
 =?utf-8?B?OEI1d2FJVjFSU250Y1NWUzJHa200a2tTYjJzUFVXZ0dFMG9CVnV2eWNtdFpG?=
 =?utf-8?B?QWFaU3Mva29nOTZEOG5EMTY1Z0J2eXZmSkZPOXJLYUxiUXpCS2hsT2wzRGJV?=
 =?utf-8?B?cFJaeTM0SXlURXdtT0hKN3l5MEV4cWhZeFZBUUtyOC9yZFZzdGs2OG9XcFJG?=
 =?utf-8?B?WE8wVHZHVzZwUDlzanlOWDhsTll1cG16MUcxWUtQTmtnZVdROERVQWk3VW1m?=
 =?utf-8?B?OWpQdGJtMkFuNUtXTkI5YjhWd3c1OFNScXdiT0E3T0Jad3gwUGowVlVZWlJj?=
 =?utf-8?B?QXl5ZmczMWpnbGs0VWdXRWkyc251Tzd5ZHMyTzJuRmtEODdyb0hzK3pFOXoz?=
 =?utf-8?B?eTIraVBla0s5UWRHeTV3b0lyZ0lvZ2FSY1Y2MW5MVmZ2c3JCV21heFFpZWRw?=
 =?utf-8?B?VW5rUkdRczNnQkw5b0F6dk1qQTgySXBkNGhkNHlGVWdUcjlPc21XZ0IwL2dn?=
 =?utf-8?B?MW9RQ0wvTkNRa0orN3lkVGFobGJPSjFTZDg1Zkk0K3IyL1pIakhwQVpVd3ha?=
 =?utf-8?B?RVhaWjVpYVg3R0RZbVZ3bnorVkd6NHdZLzNXempBczNlc0QzUTFqYnNMZTRv?=
 =?utf-8?B?N3c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4332736f-e180-4ef0-eeb6-08dad7b1ef02
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 17:47:24.7038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A/4eSsn4EyulU5tHRaOhMqh/XALSXVGos0K2P0KLKnPHGiTHNHUsnwaz7ht+2zaW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2698
X-Proofpoint-GUID: rXOwJjuA2eKXz_32YCyGvX_60JzRdEjI
X-Proofpoint-ORIG-GUID: rXOwJjuA2eKXz_32YCyGvX_60JzRdEjI
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_11,2022-12-06_01,2022-06-22_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/6/22 5:21 AM, Ilya Leoshkevich wrote:
> On Fri, 2022-12-02 at 11:36 +0100, Björn Töpel wrote:
>> From: Björn Töpel <bjorn@rivosinc.com>
>>
>> A BPF call instruction can be, correctly, marked with zext_dst set to
>> true. An example of this can be found in the BPF selftests
>> progs/bpf_cubic.c:
>>
>>    ...
>>    extern __u32 tcp_reno_undo_cwnd(struct sock *sk) __ksym;
>>
>>    __u32 BPF_STRUCT_OPS(bpf_cubic_undo_cwnd, struct sock *sk)
>>    {
>>            return tcp_reno_undo_cwnd(sk);
>>    }
>>    ...
>>
>> which compiles to:
>>    0:  r1 = *(u64 *)(r1 + 0x0)
>>    1:  call -0x1
>>    2:  exit
>>
>> The call will be marked as zext_dst set to true, and for some
>> backends
>> (bpf_jit_needs_zext() returns true) expanded to:
>>    0:  r1 = *(u64 *)(r1 + 0x0)
>>    1:  call -0x1
>>    2:  w0 = w0
>>    3:  exit
> 
> In the verifier, the marking is done by check_kfunc_call() (added in
> e6ac2450d6de), right? So the problem occurs only for kfuncs?
> 
>          /* Check return type */
>          t = btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
> 
>          ...
> 
>          if (btf_type_is_scalar(t)) {
>                  mark_reg_unknown(env, regs, BPF_REG_0);
>                  mark_btf_func_reg_size(env, BPF_REG_0, t->size);
> 
> I tried to find some official information whether the eBPF calling
> convention requires sign- or zero- extending return values and
> arguments, but unfortunately [1] doesn't mention this.
> 
> LLVM's lib/Target/BPF/BPFCallingConv.td mentions both R* and W*
> registers, but since assigning to W* leads to zero-extension, it seems
> to me that this is the case.

We actually follow the clang convention, the zero-extension is either
done in caller or callee, but not both. See 
https://reviews.llvm.org/D131598 how the convention could be changed.

The following is an example.

$ cat t.c
extern unsigned foo(void);
unsigned bar1(void) {
     return foo();
}
unsigned bar2(void) {
     if (foo()) return 10; else return 20;
}
$ clang -target bpf -mcpu=v3 -O2 -c t.c && llvm-objdump -d t.o

t.o:    file format elf64-bpf

Disassembly of section .text:

0000000000000000 <bar1>:
        0:       85 10 00 00 ff ff ff ff call -0x1
        1:       95 00 00 00 00 00 00 00 exit

0000000000000010 <bar2>:
        2:       85 10 00 00 ff ff ff ff call -0x1
        3:       bc 01 00 00 00 00 00 00 w1 = w0
        4:       b4 00 00 00 14 00 00 00 w0 = 0x14
        5:       16 01 01 00 00 00 00 00 if w1 == 0x0 goto +0x1 <LBB1_2>
        6:       b4 00 00 00 0a 00 00 00 w0 = 0xa

0000000000000038 <LBB1_2>:
        7:       95 00 00 00 00 00 00 00 exit
$

If the return value of 'foo()' is actually used in the bpf program, the
proper zero extension will be done. Otherwise, it is not done.

This is with latest llvm16. I guess we need to check llvm whether
we could enforce to add a w0 = w0 in bar1().

Otherwise, with this patch, it will add w0 = w0 in all cases which
is not necessary in most of practical cases.

> 
> If the above is correct, then shouldn't we rather use sizeof(void *) in
> the mark_btf_func_reg_size() call above?
> 
>> The opt_subreg_zext_lo32_rnd_hi32() function which is responsible for
>> the zext patching, relies on insn_def_regno() to fetch the register
>> to
>> zero-extend. However, this function does not handle call instructions
>> correctly, and opt_subreg_zext_lo32_rnd_hi32() fails the
>> verification.
>>
>> Make sure that R0 is correctly resolved for (BPF_JMP | BPF_CALL)
>> instructions.
>>
>> Fixes: 83a2881903f3 ("bpf: Account for BPF_FETCH in
>> insn_has_def32()")
>> Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
>> ---
>> I'm not super happy about the additional special case -- first
>> cmpxchg, and now call. :-( A more elegant/generic solution is
>> welcome!
>> ---
>>   kernel/bpf/verifier.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 264b3dc714cc..4f9660eafc72 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -13386,6 +13386,9 @@ static int
>> opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
>>                  if (!bpf_jit_needs_zext() && !is_cmpxchg_insn(&insn))
>>                          continue;
>>   
>> +               if (insn.code == (BPF_JMP | BPF_CALL))
>> +                       load_reg = BPF_REG_0;
>> +
>>                  if (WARN_ON(load_reg == -1)) {
>>                          verbose(env, "verifier bug. zext_dst is set,
>> but no reg is defined\n");
>>                          return -EFAULT;
>>
>> base-commit: 01f856ae6d0ca5ad0505b79bf2d22d7ca439b2a1
> 
> [1]
> https://docs.kernel.org/bpf/instruction-set.html#registers-and-calling-convention
