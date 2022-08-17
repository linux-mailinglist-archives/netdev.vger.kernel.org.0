Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7545969C7
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 08:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbiHQGre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 02:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiHQGrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 02:47:33 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730425A2CE;
        Tue, 16 Aug 2022 23:47:31 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0VMUSyp1_1660718846;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VMUSyp1_1660718846)
          by smtp.aliyun-inc.com;
          Wed, 17 Aug 2022 14:47:27 +0800
Message-ID: <1660718191.3631961-1-xuanzhuo@linux.alibaba.com>
Subject: Re: upstream kernel crashes
Date:   Wed, 17 Aug 2022 14:36:31 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     James.Bottomley@hansenpartnership.com, andres@anarazel.de,
        axboe@kernel.dk, c@redhat.com, davem@davemloft.net,
        edumazet@google.com, gregkh@linuxfoundation.org,
        jasowang@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@roeck-us.net, martin.petersen@oracle.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        torvalds@linux-foundation.org,
        virtualization@lists.linux-foundation.org,
        kasan-dev@googlegroups.com, mst@redhat.com
References: <20220815113729-mutt-send-email-mst@kernel.org>
 <20220815164503.jsoezxcm6q4u2b6j@awork3.anarazel.de>
 <20220815124748-mutt-send-email-mst@kernel.org>
 <20220815174617.z4chnftzcbv6frqr@awork3.anarazel.de>
 <20220815161423-mutt-send-email-mst@kernel.org>
 <20220815205330.m54g7vcs77r6owd6@awork3.anarazel.de>
 <20220815170444-mutt-send-email-mst@kernel.org>
 <20220817061359.200970-1-dvyukov@google.com>
In-Reply-To: <20220817061359.200970-1-dvyukov@google.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 08:13:59 +0200, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Mon, 15 Aug 2022 17:32:06 -0400, Michael wrote:
> > So if you pass the size parameter for a legacy device it will
> > try to make the ring smaller and that is not legal with
> > legacy at all. But the driver treats legacy and modern
> > the same, it allocates a smaller queue anyway.
> >
> > Lo and behold, I pass disable-modern=on to qemu and it happily
> > corrupts memory exactly the same as GCP does.
>
> Ouch!
>
> I understand that the host does the actual corruption,
> but could you think of any additional debug checking in the guest
> that would caught this in future? Potentially only when KASAN
> is enabled which can verify validity of memory ranges.
> Some kind of additional layer of sanity checking.
>
> This caused a bit of a havoc for syzbot with almost 100 unique
> crash signatures, so would be useful to catch such issues more
> reliably in future.

We can add a check to vring size before calling vp_legacy_set_queue_address().
Checking the memory range directly is a bit cumbersome.

Thanks.

diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index 2257f1b3d8ae..0673831f45b6 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -146,6 +146,8 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
                goto out_del_vq;
        }

+       BUG_ON(num != virtqueue_get_vring_size(vq));
+
        /* activate the queue */
        vp_legacy_set_queue_address(&vp_dev->ldev, index, q_pfn);


>
> Thanks
