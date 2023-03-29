Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281F16CD8C5
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 13:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjC2Lwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 07:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjC2Lwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 07:52:39 -0400
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442BB1FE2;
        Wed, 29 Mar 2023 04:52:34 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Vewqdy9_1680090750;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vewqdy9_1680090750)
          by smtp.aliyun-inc.com;
          Wed, 29 Mar 2023 19:52:31 +0800
Message-ID: <1680090663.603155-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC PATCH 0/4] eBPF RSS through QMP support.
Date:   Wed, 29 Mar 2023 19:51:03 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Andrew Melnychenko <andrew@daynix.com>
Cc:     yan@daynix.com, yuri.benditovich@daynix.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mst@redhat.com, jasowang@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20230329104546.108016-1-andrew@daynix.com>
In-Reply-To: <20230329104546.108016-1-andrew@daynix.com>
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Is this a patch-set of QEMU? If yes, why are the email lists all kernel mail
list without QEMU mail list?

Thanks.

On Wed, 29 Mar 2023 13:45:41 +0300, Andrew Melnychenko <andrew@daynix.com> wrote:
> This series of patches provides the ability to retrieve eBPF program
> through qmp, so management application may load bpf blob with proper capabilities.
> Now, virtio-net devices can accept eBPF programs and maps through properties
> as external file descriptors. Access to the eBPF map is direct through mmap()
> call, so it should not require additional capabilities to bpf* calls.
> eBPF file descriptors can be passed to QEMU from parent process or by unix
> socket with sendfd() qmp command.
>
> Overall, the basic scenario of using the helper looks like this:
>  * Libvirt checks for ebpf_fds property.
>  * Libvirt requests eBPF blob through QMP.
>  * Libvirt loads blob for virtio-net.
>  * Libvirt launches the QEMU with eBPF fds passed.
>
> Andrew Melnychenko (4):
>   ebpf: Added eBPF initialization by fds and map update.
>   virtio-net: Added property to load eBPF RSS with fds.
>   ebpf: Added declaration/initialization routines.
>   qmp: Added new command to retrieve eBPF blob.
>
>  ebpf/ebpf.c                    |  48 +++++++++++++
>  ebpf/ebpf.h                    |  25 +++++++
>  ebpf/ebpf_rss-stub.c           |   6 ++
>  ebpf/ebpf_rss.c                | 124 +++++++++++++++++++++++++++------
>  ebpf/ebpf_rss.h                |  10 +++
>  ebpf/meson.build               |   1 +
>  hw/net/virtio-net.c            |  77 ++++++++++++++++++--
>  include/hw/virtio/virtio-net.h |   1 +
>  monitor/qmp-cmds.c             |  17 +++++
>  qapi/misc.json                 |  25 +++++++
>  10 files changed, 307 insertions(+), 27 deletions(-)
>  create mode 100644 ebpf/ebpf.c
>  create mode 100644 ebpf/ebpf.h
>
> --
> 2.39.1
>
