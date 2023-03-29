Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D510B6CED2A
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjC2Pl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjC2PlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:41:19 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C7B44A2
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:41:16 -0700 (PDT)
Received: from [192.168.0.185] (ip5f5aebcb.dynamic.kabel-deutschland.de [95.90.235.203])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 5616061CC457B;
        Wed, 29 Mar 2023 17:41:13 +0200 (CEST)
Message-ID: <72691489-274c-8c3c-c897-08f74f413097@molgen.mpg.de>
Date:   Wed, 29 Mar 2023 17:41:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [Intel-wired-lan] [PATCH net-next 00/15] Introduce IDPF driver
To:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Cc:     willemb@google.com, netdev@vger.kernel.org, decot@google.com,
        shiraz.saleem@intel.com, intel-wired-lan@lists.osuosl.org
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Pavan,


Thank you very much for the new driver. It’s a lot of code. ;-)

Am 29.03.23 um 16:03 schrieb Pavan Kumar Linga:
> This patch series introduces the Infrastructure Data Path Function (IDPF)
> driver. It is used for both physical and virtual functions. Except for
> some of the device operations the rest of the functionality is the same
> for both PF and VF. IDPF uses virtchnl version2 opcodes and structures
> defined in the virtchnl2 header file which helps the driver to learn
> the capabilities and register offsets from the device Control Plane (CP)
> instead of assuming the default values.
> 
> The format of the series follows the driver init flow to interface open.
> To start with, probe gets called and kicks off the driver initialization
> by spawning the 'vc_event_task' work queue which in turn calls the
> 'hard reset' function. As part of that, the mailbox is initialized which
> is used to send/receive the virtchnl messages to/from the CP. Once that is
> done, 'core init' kicks in which requests all the required global resources
> from the CP and spawns the 'init_task' work queue to create the vports.
> 
> Based on the capability information received, the driver creates the said
> number of vports (one or many) where each vport is associated to a netdev.
> Also, each vport has its own resources such as queues, vectors etc.
>  From there, rest of the netdev_ops and data path are added.
> 
> IDPF implements both single queue which is traditional queueing model
> as well as split queue model. In split queue model, it uses separate queue
> for both completion descriptors and buffers which helps to implement
> out-of-order completions. It also helps to implement asymmetric queues,
> for example multiple RX completion queues can be processed by a single
> RX buffer queue and multiple TX buffer queues can be processed by a
> single TX completion queue. In single queue model, same queue is used
> for both descriptor completions as well as buffer completions. It also
> supports features such as generic checksum offload, generic receive
> offload (hardware GRO) etc.

[…]

Can you please elaborate on how the driver can be tested, and if tests 
are added to automatically test the driver?


Kind regards,

Paul
