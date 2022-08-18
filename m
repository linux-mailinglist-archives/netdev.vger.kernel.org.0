Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E578F598129
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239112AbiHRJ4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235275AbiHRJ4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:56:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A13B088A;
        Thu, 18 Aug 2022 02:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660816593; x=1692352593;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eqXWzEPdx2XZOUblO5chU9G8GMBdWo/1zFOTR45FRYM=;
  b=Zt+3B8MqR2zByhCnxkwR4jz+Vono/8VZaKrsHZayK7p0mBbX3cb/faVj
   Qq425pThBSmlO+1t9hRfjZ5q+3y8dU2a9Hf56Izv7gTaxx7AHyXJ5ZvJm
   4sgFF4ghaCA59LyQCPZUvDu9kloT7T81dW5y5Kv91q084ZmqwsICH952y
   hFXB21Pd8T4JbPPR9izBWaYSOWmNZihcNGzlLs3nTGybDrESW3Jv+yzoc
   IKv3q30sVM3dGDPep9aOeZAc6HLvX5FpjTLDys8f8IYYaivWpq41fhHw3
   mtH0vUIcGGLFQ0kXw00PfdTybZx3O/xCLPeDzvdagQ01l4vYNrQbLD3uE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="290285593"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="290285593"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 02:56:32 -0700
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="636757052"
Received: from mszycik-mobl.ger.corp.intel.com (HELO [10.249.132.192]) ([10.249.132.192])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 02:56:27 -0700
Message-ID: <2c659f31-f2ac-b6a9-c509-5402f61afc78@linux.intel.com>
Date:   Thu, 18 Aug 2022 11:56:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH v2 net-next] docs: net: add an explanation of VF (and
 other) Representors
Content-Language: en-US
To:     ecree@xilinx.com, netdev@vger.kernel.org, linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        michael.chan@broadcom.com, andy@greyhouse.net, saeed@kernel.org,
        jiri@resnulli.us, snelson@pensando.io, simon.horman@corigine.com,
        alexander.duyck@gmail.com, rdunlap@infradead.org,
        Edward Cree <ecree.xilinx@gmail.com>
References: <20220815142251.8909-1-ecree@xilinx.com>
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
In-Reply-To: <20220815142251.8909-1-ecree@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15-Aug-22 16:22, ecree@xilinx.com wrote:

> [...]
>
> +Motivation
> +----------
> +
> +Since the mid-2010s, network cards have started offering more complex
> +virtualisation capabilities than the legacy SR-IOV approach (with its simple
> +MAC/VLAN-based switching model) can support.  This led to a desire to offload
> +software-defined networks (such as OpenVSwitch) to these NICs to specify the
> +network connectivity of each function.  The resulting designs are variously
> +called SmartNICs or DPUs.
> +
> +Network function representors bring the standard Linux networking stack to
> +virtual switches and IOV devices.  Just as each port of a Linux-controlled
> +switch has a separate netdev, so each virtual function has one.  When the system

Maybe I'm misunderstanding something, but this sentence seems a bit confusing. Maybe:
"Just as each port of a Linux-controlled switch has a separate netdev, each virtual
function has one."?

> +boots, and before any offload is configured, all packets from the virtual
> +functions appear in the networking stack of the PF via the representors.
> +The PF can thus always communicate freely with the virtual functions.
> +The PF can configure standard Linux forwarding between representors, the uplink
> +or any other netdev (routing, bridging, TC classifiers).
>
> [...]
>
> +How do representors interact with TC rules?
> +-------------------------------------------
> +
> +Any TC rule on a representor applies (in software TC) to packets received by
> +that representor netdevice.  Thus, if the delivery part of the rule corresponds
> +to another port on the virtual switch, the driver may choose to offload it to
> +hardware, applying it to packets transmitted by the representee.
> +
> +Similarly, since a TC mirred egress action targeting the representor would (in
> +software) send the packet through the representor (and thus indirectly deliver
> +it to the representee), hardware offload should interpret this as delivery to
> +the representee.
> +
> +As a simple example, if ``eth0`` is the master PF's netdevice and ``eth1`` is a
> +VF representor, the following rules::
> +
> +    tc filter add dev eth1 parent ffff: protocol ipv4 flower \
> +        action mirred egress redirect dev eth0
> +    tc filter add dev eth0 parent ffff: protocol ipv4 flower \
> +        action mirred egress mirror dev eth1

Perhaps eth0/eth1 names could be replaced with more meaningful names, as it's easy
to confuse them now. How about examples from above (e.g. PF -> eth4, PR -> eth4pf1vf2rep)?
Or just $PF_NETDEV, $PR_NETDEV.

> +would mean that all IPv4 packets from the VF are sent out the physical port, and
> +all IPv4 packets received on the physical port are delivered to the VF in
> +addition to the master PF.
> +
> +Of course the rules can (if supported by the NIC) include packet-modifying
> +actions (e.g. VLAN push/pop), which should be performed by the virtual switch.
> +
> +Tunnel encapsulation and decapsulation are rather more complicated, as they
> +involve a third netdevice (a tunnel netdev operating in metadata mode, such as
> +a VxLAN device created with ``ip link add vxlan0 type vxlan external``) and
> +require an IP address to be bound to the underlay device (e.g. master PF or port
> +representor).  TC rules such as::
> +
> +    tc filter add dev eth1 parent ffff: flower \
> +        action tunnel_key set id $VNI src_ip $LOCAL_IP dst_ip $REMOTE_IP \
> +                              dst_port 4789 \
> +        action mirred egress redirect dev vxlan0
> +    tc filter add dev vxlan0 parent ffff: flower enc_src_ip $REMOTE_IP \
> +        enc_dst_ip $LOCAL_IP enc_key_id $VNI enc_dst_port 4789 \
> +        action tunnel_key unset action mirred egress redirect dev eth1
> +

Same as above, eth1 name could be more intuitive.

--- 8< ---

LGTM, only those two small nitpicks.

Regards,
Marcin
