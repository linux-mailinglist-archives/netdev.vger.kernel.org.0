Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 636F158B036
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 21:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237571AbiHETPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 15:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237004AbiHETPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 15:15:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6194DF07;
        Fri,  5 Aug 2022 12:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=i+098UWC6l99cEswBPhk9HEYm1VyxfN7HJa6lueXNqY=; b=YMdxLfj8Jw0WkNe8vfrkVe+jLc
        hfr7tmc7kIuSXcyBCfGc774rsepLXUJKKFb6gKjMgwMujgBUnOsALlJFwtzwHhQmkSyVgm41rqv5+
        rh8bmM7zouWQItL5vFsL9kMaiwe9G/f+lCwCL9RcwEyXZbo5Mlft1nqBO0DR8viWnqNWfax63lNJ8
        eZqhtoA0Te0A0ecXQod2AK3X1wnkQzdkP7YFjAVmSiUvcaY/JRd/xwb3qYMV3twlZCvYSDhQx25Uc
        nSkSt5bCZ5zLtzi8t0b9qSqHQm/k+37vnqjb5gIEGWoMLZix8g0Zsd3D9xNOFbuPbS+BQRgYiOuLg
        spF8fHmQ==;
Received: from [2601:1c0:6280:3f0::a6b3]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oK2mw-0007RR-Vo; Fri, 05 Aug 2022 19:15:15 +0000
Message-ID: <c389fb10-6eaf-7a86-6d50-f195eb29dd38@infradead.org>
Date:   Fri, 5 Aug 2022 12:15:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH net-next] docs: net: add an explanation of VF (and
 other) Representors
Content-Language: en-US
To:     ecree@xilinx.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        Edward Cree <ecree.xilinx@gmail.com>, linux-net-drivers@amd.com
References: <20220805165850.50160-1-ecree@xilinx.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220805165850.50160-1-ecree@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

On 8/5/22 09:58, ecree@xilinx.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> There's no clear explanation of what VF Representors are for, their
>  semantics, etc., outside of vendor docs and random conference slides.
> Add a document explaining Representors and defining what drivers that
>  implement them are expected to do.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
> diff --git a/Documentation/networking/representors.rst b/Documentation/networking/representors.rst
> new file mode 100644
> index 000000000000..4d28731a5b5b
> --- /dev/null
> +++ b/Documentation/networking/representors.rst
> @@ -0,0 +1,219 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=============================
> +Network Function Representors
> +=============================
> +
> +This document describes the semantics and usage of representor netdevices, as
> +used to control internal switching on SmartNICs.  For the closely-related port
> +representors on physical (multi-port) switches, see
> +:ref:`Documentation/networking/switchdev.rst <switchdev>`.
> +
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
> +Network function representors provide the mechanism by which network functions
> +on an internal switch are managed.  They are used both to configure the
> +corresponding function ('representee') and to handle slow-path traffic to and
> +from the representee for which no fast-path switching rule is matched.
> +
> +That is, a representor is both a control plane object (representing the function
> +in administrative commands) and a data plane object (one end of a virtual pipe).
> +As a virtual link endpoint, the representor can be configured like any other
> +netdevice; in some cases (e.g. link state) the representee will follow the
> +representor's configuration, while in others there are separate APIs to
> +configure the representee.
> +
> +What does a representor do?
> +---------------------------
> +
> +A representor has three main rôles.

Just use "roles". dict.org and m-w.com are happy with that.
m-w.com says for "role":
  variants: or less commonly rôle

thanks.
-- 
~Randy
