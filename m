Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342461CEB80
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgELDbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728110AbgELDbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:31:47 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB21BC061A0C;
        Mon, 11 May 2020 20:31:46 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a7so8726909pju.2;
        Mon, 11 May 2020 20:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JOBjSfGyga4J2bultUu8C36lMC4c3/xrTuU9mZgKClQ=;
        b=bGr2ppOXgbUllfIAwrSc3/q4YVcPEH1G+JnkyINUX6ju6prSmQjhFCb+YKTq/C3kv2
         kCRVAxDYepbwAoZifUrDir969DQBQVIhqf7+aHtl50VJWpCwq5TOlV/Vu8ekivQOfiyR
         y6EQHDagxouZMuzmisdV/ds8NTAUVlUY0okxGE87yznrXQ0oTsccwV41/Wo9KYvsmSQX
         yxrSEHWbK/Quv8Jwud9cgudwNP7lsjVhMzJ23cZrLP/aSQ4tGOFwfUIftvx+c5HdgtX5
         /uVNvW7xfuzzxrbExUR0r3joW/RfM9KiDP9ZP9Y0mjS6uxF20diTbR5kWjDQWEddU7vS
         aE/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JOBjSfGyga4J2bultUu8C36lMC4c3/xrTuU9mZgKClQ=;
        b=BA7zzkD8aFbPNfAbEz0yXewed4CjPaUn4QkedumSg86Kd/HCvk0Ie6SKSy7qvivbMU
         pyeh73JS43Ndr+fscbfe8QQJ8rBpnI2mLgd+xg68g11GrGtVAwFGJCa4tm56JktUr7dY
         20p/sd9WT+E2nOklBLOVlvmmOIrEEKGsYA+salqUVRFrTGd2/5s6+O5s0ituyJrGBTDg
         oJyBrjdQttNzg6GxKb8Vx1RR6i6Rm3sDaYAp5oYh7hsQxbp5RKluyaoZWXP9vbxkgmYT
         fVJfqAfbPyXdZGAEU6bfKYuP66asqEIpbT9U+wLofjk0sxAAbBZXh8szM88SbNCu4iHz
         YOVQ==
X-Gm-Message-State: AGi0PubKtaB34u4EPGS3BjdVaWBDZz6YCCFqBrll9Gu1ybm3jEc9uR84
        wQtdJjkKTtI1in+pog0xSYq51J+I
X-Google-Smtp-Source: APiQypKQV6EK1pgnxQiqGRIdYt3auisBY+Pqo4DhrT1wXg3EcQ5cmc+qneRHF6Mx8VhCnGMisNDjSQ==
X-Received: by 2002:a17:902:c40c:: with SMTP id k12mr19034039plk.238.1589254305758;
        Mon, 11 May 2020 20:31:45 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h6sm11650411pje.37.2020.05.11.20.31.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 20:31:45 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 05/15] net: dsa: sja1105: save/restore VLANs
 using a delta commit method
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511135338.20263-1-olteanv@gmail.com>
 <20200511135338.20263-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fd4513d7-900d-fa33-8c3e-23bd2824b27b@gmail.com>
Date:   Mon, 11 May 2020 20:31:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511135338.20263-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 6:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Managing the VLAN table that is present in hardware will become very
> difficult once we add a third operating state
> (best_effort_vlan_filtering). That is because correct cleanup (not too
> little, not too much) becomes virtually impossible, when VLANs can be
> added from the bridge layer, from dsa_8021q for basic tagging, for
> cross-chip bridging, as well as retagging rules for sub-VLANs and
> cross-chip sub-VLANs. So we need to rethink VLAN interaction with the
> switch in a more scalable way.
> 
> In preparation for that, use the priv->expect_dsa_8021q boolean to
> classify any VLAN request received through .port_vlan_add or
> .port_vlan_del towards either one of 2 internal lists: bridge VLANs and
> dsa_8021q VLANs.
> 
> Then, implement a central sja1105_build_vlan_table method that creates a
> VLAN configuration from scratch based on the 2 lists of VLANs kept by
> the driver, and based on the VLAN awareness state. Currently, if we are
> VLAN-unaware, install the dsa_8021q VLANs, otherwise the bridge VLANs.
> 
> Then, implement a delta commit procedure that identifies which VLANs
> from this new configuration are actually different from the config
> previously committed to hardware. We apply the delta through the dynamic
> configuration interface (we don't reset the switch). The result is that
> the hardware should see the exact sequence of operations as before this
> patch.
> 
> This also helps remove the "br" argument passed to
> dsa_8021q_crosschip_bridge_join, which it was only using to figure out
> whether it should commit the configuration back to us or not, based on
> the VLAN awareness state of the bridge. We can simplify that, by always
> allowing those VLANs inside of our dsa_8021q_vlans list, and committing
> those to hardware when necessary.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
