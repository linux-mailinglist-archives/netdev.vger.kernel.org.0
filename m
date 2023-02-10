Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C716922DE
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 17:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbjBJQBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 11:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbjBJQBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 11:01:47 -0500
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C686E894;
        Fri, 10 Feb 2023 08:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=naNDkToztiCnoM9Pbw5Ic6EFdRUS13ckF9svYg2+XVA=; b=ngYzpxrjZpUVgamxuOoOWEurXr
        MmD9YFx31Cq+GhrbmVBMT0oy5+zSiaOu899eeNWDxiAU/XtviHQXoFLlPi22DETSR3I8/nbqmLupu
        I9bIKQ/UgLmKm4aw4VzLqI+mvZX4p3N8NQ/kVXFvyAbjFaXLRnfJ9F+4gNkUWE1qYZ6WrbVy5Caff
        ILPiPAkR3wYOSwInj6hy8O3oCmM7RW7yyn0VJE5pM0mfvqJtSYLGIsyZmz5N0EDSMBxdAgsawAS8b
        6iqE6ZJbxbq1UDYw81Y8cqHw9IAxKaHfXdtMhPTN2Zj4tSuYhLuIlx47ESRH/cYfVzDosfyV4qHeL
        W5WDUHVw==;
Received: from [187.10.60.16] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1pQVqD-00FBW6-Tv; Fri, 10 Feb 2023 17:01:38 +0100
Message-ID: <9efcde8e-c87e-43ff-4d66-5f448d111940@igalia.com>
Date:   Fri, 10 Feb 2023 13:01:32 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH V3 08/11] EDAC/altera: Skip the panic notifier if kdump is
 loaded
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>, pmladek@suse.com
Cc:     linux-edac@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, Dinh Nguyen <dinguyen@kernel.org>,
        Rabara Niravkumar L <niravkumar.l.rabara@intel.com>,
        Tony Luck <tony.luck@intel.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-9-gpiccoli@igalia.com>
 <742d2a7e-efee-e212-178e-ba642ec94e2a@igalia.com>
 <eaba1a1a-31cd-932f-277c-267699d7be30@igalia.com> <Y3zlghMzlc1kzVJx@zn.tnic>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <Y3zlghMzlc1kzVJx@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Boris and Petr, first of all thanks for your great analysis and
really sorry for the huge delay in my response.

Below I'm pasting the 2 relevant responses from both Petr and Boris.


On 22/11/2022 12:06, Borislav Petkov wrote:
> On Tue, Nov 22, 2022 at 10:33:12AM -0300, Guilherme G. Piccoli wrote:
> 
> Leaving in the whole thing for newly added people.
> 
>> On 18/09/2022 11:10, Guilherme G. Piccoli wrote:
>>> On 19/08/2022 19:17, Guilherme G. Piccoli wrote:
>>>> The altera_edac panic notifier performs some data collection with
>>>> regards errors detected; such code relies in the regmap layer to
>>>> perform reads/writes, so the code is abstracted and there is some
>>>> risk level to execute that, since the panic path runs in atomic
>>>> context, with interrupts/preemption and secondary CPUs disabled.
>>>>
>>>> Users want the information collected in this panic notifier though,
>>>> so in order to balance the risk/benefit, let's skip the altera panic
>>>> notifier if kdump is loaded. While at it, remove a useless header
>>>> and encompass a macro inside the sole ifdef block it is used.
>>>>
>>>> Cc: Borislav Petkov <bp@alien8.de>
>>>> Cc: Petr Mladek <pmladek@suse.com>
>>>> Cc: Tony Luck <tony.luck@intel.com>
>>>> Acked-by: Dinh Nguyen <dinguyen@kernel.org>
>>>> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
>>>>
>>>> ---
>>>>
>>>> V3:
>>>> - added the ack tag from Dinh - thanks!
>>>> - had a good discussion with Boris about that in V2 [0],
>>>> hopefully we can continue and reach a consensus in this V3.
>>>> [0] https://lore.kernel.org/lkml/46137c67-25b4-6657-33b7-cffdc7afc0d7@igalia.com/
>>>>
>>>> V2:
>>>> - new patch, based on the discussion in [1].
>>>> [1] https://lore.kernel.org/lkml/62a63fc2-346f-f375-043a-fa21385279df@igalia.com/
>>>>
>>>> [...]
>>>
>>> Hi Dinh, Tony, Boris - sorry for the ping.
>>>
>>> Appreciate reviews on this one - Dinh already ACKed the patch but Boris
>>> raised some points in the past version [0], so any opinions or
>>> discussions are welcome!
>>
>>
>> Hi folks, monthly ping heheh
>> Apologies for the re-pings, please let me know if there is anything
>> required to move on this patch.
> 
> Looking at this again, I really don't like the sprinkling of
> 
> 	if (kexec_crash_loaded())
> 
> in unrelated code. And I still think that the real fix here is to kill
> this
> 
> 	edac->panic_notifier
> 
> thing. And replace it with simply logging the error from the double bit
> error interrupt handle. That DBERR IRQ thing altr_edac_a10_irq_handler().
> Because this is what this panic notifier does - dump double-bit errors.
> 
> Now, if Dinh doesn't move, I guess we can ask Tony and/or Rabara (he has
> sent a patch for this driver recently and Altera belongs to Intel now)
> to find someone who can test such a change and we (you could give it a
> try first :)) can do that change.
> 
> Thx.
> 

On 09/12/2022 13:03, Petr Mladek wrote:> [...]>
> I have read the discussion about v2 [1] and this looks like a bad
> approach from my POV.
>
> My understanding is that the information provided by this notifier
> could not be found in the crashdump. It means that people really
> want to run this before crashdump in principle.
>
> Of course, there is the question how much safe this code is. I mean
> if the panic() code path might get blocked here.
>
> I see two possibilities.
>
> The best solution would be if we know that this is "always" safe or if
> it can be done a safe way. Then we could keep it as it is or implement
> the safe way.
>
> Alternative solution would be to create a kernel parameter that
> would enable/disable this particular report when kdump is enabled.
> The question would be the default. It would depend on how risky
> the code is and how useful the information is.
>
> [1] https://lore.kernel.org/r/20220719195325.402745-11-gpiccoli@igalia.com
>


So, for me Petr approach is the more straightforward, though we could
rethink the idea of this notifier being...a notifier, as suggest Boris heh

Anyway, what I plan to do is: I'll re-submit a simple clean-up for this
code (header / ifdef stuff), not functional-changing the code path.

After that, when re-submitting the V2 or the notifiers refactor (which
I'm pending for some good months =O ), I'll deal with this code
properly, factoring the ideas and proposing a meaningful change.

So, let's discard this patch for now.
Thanks again,


Guilherme
