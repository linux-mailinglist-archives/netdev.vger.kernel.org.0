Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFA16F25E5
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 20:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjD2SpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 14:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjD2SpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 14:45:19 -0400
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40141BC9
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 11:45:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682793901; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=DVmHqGdixPRmlo3xBaQ84ts9QyctDKUamnTHz9Af3GefhkG5sXw43MDu24EQb6WqXlLhs6JN3R9EhSLJnr8VYn0MAYnnnBz2rD53PxlGqLYxvxwXiuu2SHI4VhITBC69GQPWTyS5BU5H9pe65nhyYrq3umkYEyKnVmSYmIQdEyk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682793901; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=0RmpXtbJyx8uIU3PABU11Gm7L3df9eL4hL0TCeIheTQ=; 
        b=DjPpIEpT0xp+fJJINymgVtA5G4FjYUDzD3aIOVuHW89KIYid+vzlM5LtkkaShw5BcfaUceHK/tPd4fJ/pZvl0jonKJ+uLZIAgnIQBzFDSwKcPKl/LuUHv1deF+JNAacytWlYWDCFd4cwhSaNokopsu6x9R5BGJcV0l2fvMooea8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682793901;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=0RmpXtbJyx8uIU3PABU11Gm7L3df9eL4hL0TCeIheTQ=;
        b=TskXoRc/BZ+OOhKfz8GNjhcd6hxXvsfLmv82ggZ//ApBcbTElxTQLbi+19q/7KIo
        G+8hY7CVDQIEXLELiRGFYWP8jWBqiPziom/38M4rtb+9jryMjKBhJ5pei9kuQ2x6/Bd
        mIbktRRGXXKPco5VK0S1kgoDvCPzBAwYYIPEyIq4=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1682793899018958.3142423275892; Sat, 29 Apr 2023 11:44:59 -0700 (PDT)
Message-ID: <837429f4-01be-0cbf-82d7-52fc7b1c8b50@arinc9.com>
Date:   Sat, 29 Apr 2023 21:44:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: MT7530 bug, forward broadcast and unknown frames to the correct
 CPU port
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Greg Ungerer <gerg@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
        bartel.eerdekens@constell8.be, netdev <netdev@vger.kernel.org>
References: <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <20230426205450.kez5m5jr4xch7hql@skbuf>
 <0183eb91-8517-f40f-c2bb-b229e45d6fa5@arinc9.com>
 <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <20230426205450.kez5m5jr4xch7hql@skbuf>
 <0183eb91-8517-f40f-c2bb-b229e45d6fa5@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <20230429173522.tqd7izelbhr4rvqz@skbuf>
 <680eea9a-e719-bbb1-0c7c-1b843ed2afcd@arinc9.com>
In-Reply-To: <680eea9a-e719-bbb1-0c7c-1b843ed2afcd@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.04.2023 21:39, Arınç ÜNAL wrote:
> On 29.04.2023 20:35, Vladimir Oltean wrote:
>> On Sat, Apr 29, 2023 at 04:03:57PM +0300, Arınç ÜNAL wrote:
>>> This is the final diff I'm going to submit to net.
>>>
>>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>>> index 4d5c5820e461..cc5fa641b026 100644
>>> --- a/drivers/net/dsa/mt7530.c
>>> +++ b/drivers/net/dsa/mt7530.c
>>> @@ -1008,9 +1008,9 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, 
>>> int port)
>>>       mt7530_write(priv, MT7530_PVC_P(port),
>>>                PORT_SPEC_TAG);
>>> -    /* Disable flooding by default */
>>> -    mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | 
>>> UNU_FFP_MASK,
>>> -           BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | 
>>> UNU_FFP(BIT(port)));
>>> +    /* Enable flooding on the CPU port */
>>> +    mt7530_set(priv, MT7530_MFC, BC_FFP(BIT(port)) | 
>>> UNM_FFP(BIT(port)) |
>>> +           UNU_FFP(BIT(port)));
>>>       /* Set CPU port number */
>>>       if (priv->id == ID_MT7621)
>>> @@ -2225,6 +2225,10 @@ mt7530_setup(struct dsa_switch *ds)
>>>           /* Disable learning by default on all ports */
>>>           mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
>>> +        /* Disable flooding on all ports */
>>> +        mt7530_clear(priv, MT7530_MFC, BC_FFP(BIT(i)) | 
>>> UNM_FFP(BIT(i)) |
>>> +                 UNU_FFP(BIT(i)));
>>> +
>>>           if (dsa_is_cpu_port(ds, i)) {
>>>               ret = mt753x_cpu_port_enable(ds, i);
>>>               if (ret)
>>> @@ -2412,6 +2416,10 @@ mt7531_setup(struct dsa_switch *ds)
>>>           mt7530_set(priv, MT7531_DBG_CNT(i), MT7531_DIS_CLR);
>>> +        /* Disable flooding on all ports */
>>> +        mt7530_clear(priv, MT7530_MFC, BC_FFP(BIT(i)) | 
>>> UNM_FFP(BIT(i)) |
>>> +                 UNU_FFP(BIT(i)));
>>> +
>>>           if (dsa_is_cpu_port(ds, i)) {
>>>               ret = mt753x_cpu_port_enable(ds, i);
>>>               if (ret)
>>
>> Looks ok, but considering that the register is the same for all ports,
>> then instead of accessing the hardware one by one for each port, you
>> could issue a single:
>>
>>     mt7530_clear(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | 
>> UNU_FFP_MASK);
>>
>> before the per-port for loop.
> 
> Will do, thanks.
> 
> The preferred port operation should be in the clear after this diff:
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index cb0f138d39eb..3a69ef68ceae 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -967,6 +967,10 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int 
> port)
>       if (priv->id == ID_MT7621)
>           mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
> 
> +    /* Set the CPU port for MT7531 and switch on MT7988 SoC */
> +    if (priv->id == ID_MT7531 || priv->id == ID_MT7988)
> +        mt7530_set(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK, BIT(port));

Should be 'mt7530_set(priv, MT7531_CFC, 
MT7531_CPU_PMAP_MASK(BIT(port)));' instead.

> +
>       /* CPU port gets connected to all user ports of
>        * the switch.
>        */
> @@ -2321,15 +2325,6 @@ mt7531_setup_common(struct dsa_switch *ds)
>       struct dsa_port *cpu_dp;
>       int ret, i;
> 
> -    /* BPDU to CPU port */
> -    dsa_switch_for_each_cpu_port(cpu_dp, ds) {
> -        mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
> -               BIT(cpu_dp->index));
> -        break;
> -    }
> -    mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
> -           MT753X_BPDU_CPU_ONLY);
> -
>       /* Enable and reset MIB counters */
>       mt7530_mib_reset(ds);
> 
> @@ -2360,6 +2355,10 @@ mt7531_setup_common(struct dsa_switch *ds)
>                  PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
>       }
> 
> +    /* Trap BPDUs to the CPU port */
> +    mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
> +           MT753X_BPDU_CPU_ONLY);
> +
>       /* Flush the FDB table */
>       ret = mt7530_fdb_cmd(priv, MT7530_FDB_FLUSH, NULL);
>       if (ret < 0)
> 
> The MT7531 manual states that the CPU_PMAP bits are unset after reset so
> no need to clear it beforehand.
> 
> Are you fine with the preferred port patch now that I mentioned port 6
> would be preferred for MT7531BE since it's got 2.5G whilst port 5 has
> got 1G? Would you like to submit it or leave it to me to send the diff
> above and this?
> 
> Arınç
