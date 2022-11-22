Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F4C633EFD
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbiKVOb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbiKVObM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:31:12 -0500
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5C96AED5;
        Tue, 22 Nov 2022 06:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
        Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wwK1w0+91VyguQf6bkuN05BbJdwqncc33oWAjgq88to=; b=cWFBDVu7Z4yOUp25p3/Rhx9Bdl
        jXtrRVKBSjhnWmi0UBLDnpAlDvXqGeWjL/lxbSKH+uqaeAwWzcbHIrtkhECJxYdDZpE4RliW2Gh4x
        0/f3g9/x1wbiB9QUTEvtOjTOqAUc4SO/040zHb8itMT2OK3t5HlVE3jD1cD2lrhtmpvhhnSLWJnbZ
        s/WcYjk5HX14UrkxoX6LpW5vikmrG3MVrL2vaLT0p8q7fLHd9kSpgnZPPaTI21DWwW9pUcTLSWM9E
        hoFQtO+kfOmLkrxuBnmDqqu6KrhXivaaMip3Jlygj/6+1rpd4WB4L9vQGppRnXC27E08J5D7zPV2w
        wG1mgrmQ==;
Received: from [177.102.6.147] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oxTOp-006y6v-Gr; Tue, 22 Nov 2022 14:33:19 +0100
Message-ID: <eaba1a1a-31cd-932f-277c-267699d7be30@igalia.com>
Date:   Tue, 22 Nov 2022 10:33:12 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH V3 08/11] EDAC/altera: Skip the panic notifier if kdump is
 loaded
Content-Language: en-US
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     Dinh Nguyen <dinguyen@kernel.org>, Tony Luck <tony.luck@intel.com>,
        linux-edac@vger.kernel.org, bp@alien8.de
Cc:     kexec@lists.infradead.org, pmladek@suse.com,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-9-gpiccoli@igalia.com>
 <742d2a7e-efee-e212-178e-ba642ec94e2a@igalia.com>
In-Reply-To: <742d2a7e-efee-e212-178e-ba642ec94e2a@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2022 11:10, Guilherme G. Piccoli wrote:
> On 19/08/2022 19:17, Guilherme G. Piccoli wrote:
>> The altera_edac panic notifier performs some data collection with
>> regards errors detected; such code relies in the regmap layer to
>> perform reads/writes, so the code is abstracted and there is some
>> risk level to execute that, since the panic path runs in atomic
>> context, with interrupts/preemption and secondary CPUs disabled.
>>
>> Users want the information collected in this panic notifier though,
>> so in order to balance the risk/benefit, let's skip the altera panic
>> notifier if kdump is loaded. While at it, remove a useless header
>> and encompass a macro inside the sole ifdef block it is used.
>>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Petr Mladek <pmladek@suse.com>
>> Cc: Tony Luck <tony.luck@intel.com>
>> Acked-by: Dinh Nguyen <dinguyen@kernel.org>
>> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
>>
>> ---
>>
>> V3:
>> - added the ack tag from Dinh - thanks!
>> - had a good discussion with Boris about that in V2 [0],
>> hopefully we can continue and reach a consensus in this V3.
>> [0] https://lore.kernel.org/lkml/46137c67-25b4-6657-33b7-cffdc7afc0d7@igalia.com/
>>
>> V2:
>> - new patch, based on the discussion in [1].
>> [1] https://lore.kernel.org/lkml/62a63fc2-346f-f375-043a-fa21385279df@igalia.com/
>>
>> [...]
> 
> Hi Dinh, Tony, Boris - sorry for the ping.
> 
> Appreciate reviews on this one - Dinh already ACKed the patch but Boris
> raised some points in the past version [0], so any opinions or
> discussions are welcome!


Hi folks, monthly ping heheh
Apologies for the re-pings, please let me know if there is anything
required to move on this patch.

Cheers,


Guilherme


P.S. I've been trimming the huge CC list in the series, done it here as
well.
