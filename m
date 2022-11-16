Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB6162CD27
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 22:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238900AbiKPVv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 16:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238998AbiKPVvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 16:51:00 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD346BDDC;
        Wed, 16 Nov 2022 13:50:11 -0800 (PST)
Message-ID: <475cc762-5183-90c8-a347-cc1dfa5c1976@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668635410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f8tDS2E/rfOvHtRZr1ZxwOkAC6UWU/9cveBrm7Gnkpk=;
        b=Uj+JvpJsavOL5EznkcZGdWhZbiIJ3RcMUOR6JnJEuIpngElxbQycQMaofOMJGitG4Wt7wA
        M8W2sl5ghBa0aE59nSsKcIjZI6heSg4xwQEKQBuUuDx/cCGu2k1gTX+7j5txSpBfdtAubQ
        E2vu216Ifw7RE7Xl84UDrOKHPQT8W7E=
Date:   Wed, 16 Nov 2022 13:49:58 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 06/11] xdp: Carry over xdp metadata into skb
 context
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
References: <20221115030210.3159213-1-sdf@google.com>
 <20221115030210.3159213-7-sdf@google.com>
 <20221116131253.6703f1c6@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221116131253.6703f1c6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/22 1:12 PM, Jakub Kicinski wrote:
> On Mon, 14 Nov 2022 19:02:05 -0800 Stanislav Fomichev wrote:
>> Implement new bpf_xdp_metadata_export_to_skb kfunc which
>> prepares compatible xdp metadata for kernel consumption.
>> This kfunc should be called prior to bpf_redirect
>> or when XDP_PASS'ing the frame into the kernel (note, the drivers
>> have to be updated to enable consuming XDP_PASS'ed metadata).
>>
>> veth driver is amended to consume this metadata when converting to skb.
>>
>> Internally, XDP_FLAGS_HAS_SKB_METADATA flag is used to indicate
>> whether the frame has skb metadata. The metadata is currently
>> stored prior to xdp->data_meta. bpf_xdp_adjust_meta refuses
>> to work after a call to bpf_xdp_metadata_export_to_skb (can lift
>> this requirement later on if needed, we'd have to memmove
>> xdp_skb_metadata).
> 
> IMO we should split the xdp -> skb work from the pure HW data access
> in XDP. We have a proof point here that there is a way of building
> on top of the first 5 patches to achieve the objective, and that's
> sufficient to let the prior work going in.

+1

Good idea.
