Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05684BB370
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 08:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiBRHdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 02:33:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbiBRHds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 02:33:48 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8D329410F;
        Thu, 17 Feb 2022 23:33:31 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V4oR9e._1645169608;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V4oR9e._1645169608)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 18 Feb 2022 15:33:28 +0800
Date:   Fri, 18 Feb 2022 15:33:27 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Hendrik Brueckner <brueckner@linux.ibm.com>
Cc:     Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] net/smc: Add autocork support
Message-ID: <20220218073327.GB5443@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20220216034903.20173-1-dust.li@linux.alibaba.com>
 <68e9534b-7ff5-5a65-9017-124dbae0c74b@linux.ibm.com>
 <20220216152721.GB39286@linux.alibaba.com>
 <454b5efd-e611-2dfb-e462-e7ceaee0da4d@linux.ibm.com>
 <20220217132200.GA5443@linux.alibaba.com>
 <Yg6Q2kIDJrhvNVz7@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg6Q2kIDJrhvNVz7@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 07:15:54PM +0100, Hendrik Brueckner wrote:
>On Thu, Feb 17, 2022 at 09:22:00PM +0800, dust.li wrote:
>> On Thu, Feb 17, 2022 at 10:37:28AM +0100, Stefan Raspl wrote:
>> >On 2/16/22 16:27, dust.li wrote:
>> >> On Wed, Feb 16, 2022 at 02:58:32PM +0100, Stefan Raspl wrote:
>> >> > On 2/16/22 04:49, Dust Li wrote:
>> >> >
>> 
>> >Now we understand that cloud workloads are a bit different, and the desire to
>> >be able to modify the environment of a container while leaving the container
>> >image unmodified is understandable. But then again, enabling the base image
>> >would be the cloud way to address this. The question to us is: How do other
>> >parts of the kernel address this?
>> 
>> I'm not familiar with K8S, but from one of my colleague who has worked
>> in that area tells me for resources like CPU/MEM and configurations
>> like sysctl, can be set using K8S configuration:
>> https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/
>
>For K8s, this involves container engines like cri-o, containerd, podman,
>and others towards the runtimes like runc.  To ensure they operate together,
>specifications by the Open Container Initiative (OCI) at
>https://opencontainers.org/release-notices/overview/
>
>For container/pod deployments, there is especially the Container Runtime
>Interface (CRI) that defines the interface, e.g., of K8s to cri-o etc.
>
>CRI includes support for (namespaced) sysctl's:
>https://github.com/opencontainers/runtime-spec/releases/tag/v1.0.2
>
>In essence, the CRI spec would allow users to specify/control a specific
>runtime for the container in a declarative way w/o modifying the (base)
>container images.

Thanks a lot for your kind explanation !

After a quick look at the OCI spec, I saw the support for file based
configuration (Including sysfs/procfs etc.). And unfortunately, no
netlink support.


Hi Karsten & Stefan:
Back to the patch itself, do you think I need to add the control switch
now ? Or just leave the switch and fix other issues first ?

Thanks
