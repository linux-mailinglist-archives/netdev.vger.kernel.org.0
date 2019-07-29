Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B238C782F3
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 03:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbfG2BEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 21:04:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56114 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfG2BEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 21:04:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6T13Z7j002189;
        Mon, 29 Jul 2019 01:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=PdcdzZqByBsaJyFO6zEiMqm8RLM0rmvXzok8u84h7X0=;
 b=B82Lq/jHSPm245ufPF5M6jy2Eo6E1wZPk3U4D7Yb5mvr3xuSNflB6H5sN+awMaP5/Nx5
 /TbzU3VSBQ4la/fRMI5hdNQA8u9NbGBkC4UdGEw0tksCWU8hqsMbBUukJyQ6YrF420TU
 RWQPElUdaIj/mdBhdRahbwuZc8c8WNnR1h1XH6h7RpjEPDVy/KmdoHcpKyVLU5MMLO+6
 BwkhFag5ysFg1ATmZqnmPp/pMnh8rwoaRTzyxu/hT3vzGzUaDQDvfWmomyhjB0pq4voa
 Kcc7DZehQqFfwpxyDZ69ha2zE6pGOmd2xAMyf7ivC72uW7QsQBZCGZKmjXT4viLBEv9w 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u0e1tcfc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Jul 2019 01:03:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6T12tCC124045;
        Mon, 29 Jul 2019 01:03:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2u0ee3n58p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Jul 2019 01:03:33 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6T13UEn008054;
        Mon, 29 Jul 2019 01:03:30 GMT
Received: from [192.168.1.14] (/180.165.87.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 28 Jul 2019 18:03:30 -0700
Subject: Re: memory leak in bio_copy_user_iov
To:     syzbot <syzbot+03e5c8ebd22cc6c3a8cb@syzkaller.appspotmail.com>,
        agk@redhat.com, axboe@kernel.dk, coreteam@netfilter.org,
        davem@davemloft.net, dm-devel@redhat.com, hdanton@sina.com,
        kaber@trash.net, kadlec@blackhole.kfki.hu,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        shli@kernel.org, snitzer@redhat.com,
        syzkaller-bugs@googlegroups.com
References: <000000000000aec4ec058ec71a3d@google.com>
From:   Bob Liu <bob.liu@oracle.com>
Message-ID: <81dcfa59-152c-4f22-2054-615662364394@oracle.com>
Date:   Mon, 29 Jul 2019 09:03:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <000000000000aec4ec058ec71a3d@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9332 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907290010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9332 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907290010
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/19 8:38 AM, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 664820265d70a759dceca87b6eb200cd2b93cda8
> Author: Mike Snitzer <snitzer@redhat.com>
> Date:   Thu Feb 18 20:44:39 2016 +0000
> 
>     dm: do not return target from dm_get_live_table_for_ioctl()
> 

This(and previous bisection) look not related to the reported leak.


A possible reason may be KASAN can't recognize the failure path of bio_alloc_bioset()
where mempool_free() is called but not kmalloc(p).

But it's not a real bug, because we have the condition if (nr_iovecs > inline_vecs).

Below fix may avoid the syzbot bug report..

diff --git a/block/bio.c b/block/bio.c
index 4db1008..04a7879 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -513,8 +513,10 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, unsigned int nr_iovecs,
                        bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, &bs->bvec_pool);
                }
 
-               if (unlikely(!bvl))
-                       goto err_free;
+               if (unlikely(!bvl)) {
+                       mempool_free(p, &bs->bio_pool);
+                       return NULL;
+               }
 
                bio->bi_flags |= idx << BVEC_POOL_OFFSET;
        } else if (nr_iovecs) {
@@ -525,10 +527,6 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, unsigned int nr_iovecs,
        bio->bi_max_vecs = nr_iovecs;
        bio->bi_io_vec = bvl;
        return bio;
-
-err_free:
-       mempool_free(p, &bs->bio_pool);
-       return NULL;
 }
 EXPORT_SYMBOL(bio_alloc_bioset);


Regards, -Bob

> bisection log:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_bisect.txt-3Fx-3D13f4eb64600000&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=MNjYy_nft_s0ErmK2n89p7y2yhKmeWlxWch0z7_dsm8&e=start commit:   0011572c Merge branch 'for-5.2-fixes' of git://git.kernel...
> git tree:       upstream
> final crash:    https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_report.txt-3Fx-3D100ceb64600000&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=iviPOQNPEIjkuqBma_VWEQ9l1Ve3eOiTwads42E4ZPo&e=console output: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D17f4eb64600000&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=MBwnFwjEcSQfYymfv8EYt_EawVdK9vD-OAqDMutO-YY&e=kernel config:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_.config-3Fx-3Dcb38d33cd06d8d48&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=SqmDUenNFS-961PGgiMW5mIUv0nIBrf0oBrzUxYZ8Do&e=dashboard link:
> https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_bug-3Fextid-3D03e5c8ebd22cc6c3a8cb&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=jKd2ocY5X94uyB8Or-OC3yffbOgClPQPlXqFnLzvvSY&e=syz repro:      https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.syz-3Fx-3D13244221a00000&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=K-C39Kcd1oEOtJKwnby-s1EyEZZA10mr9bcXZ0J9Kh0&e=C reproducer:   https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.c-3Fx-3D117b2432a00000&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=7J685CwQN6_FA2KgO3Vgy1msF0zi5O0OqZj_bgvEqBE&e=
> Reported-by: syzbot+03e5c8ebd22cc6c3a8cb@syzkaller.appspotmail.com
> Fixes: 664820265d70 ("dm: do not return target from dm_get_live_table_for_ioctl()")
> 
> For information about bisection process see: https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ-23bisection&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=rs52TkiEQCrV4V8YQa2wT55HD8E-0AX9pn7MNIDcje4&e=

