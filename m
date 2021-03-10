Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC683334718
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 19:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbhCJSqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 13:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhCJSpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 13:45:44 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40F6C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 10:45:44 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id o10so11981947pgg.4
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 10:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6xelsYwEgF6SwUFAYOCHQyzQg8CNSOriAMwbfHkT4IA=;
        b=FELHomFRIsxa00tC4UP0Yfp3Qi/F6q9nnwyzZW3QB+NhXgGMyfqRg+kWiJVWjM7r/r
         kGmz0Sg9yv/VclWOK1U1giZ6QnhLVQuXbNRw/jDuYKNXP6BbWDfEHBCDTZ3gLZlzzbt7
         04ygyLqywDneThH7f3lIEQmSo8O7OeCz/jwzE2afs3gvY72jMraWCbfMrjFtj159cUTf
         j2caGVxwxSMYYYF1o/OOGQFJG59E6vikETgzHIHbDxgn3UupIbSkaVsIWX2242QkY3mF
         QA+0HUVyYqJqlgd4E3MRjTfSwk7AKaHDp9M5a6IqsZHS5YwY+h5VFUZb4S9zoV+DIwJF
         NfTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6xelsYwEgF6SwUFAYOCHQyzQg8CNSOriAMwbfHkT4IA=;
        b=jHpzhYQ4JA8oyAOjH4lBhwMjzexgBYd5z8vSEaFoCWTYnkpNMv4v6GBRD/SvCfZPIP
         82nlo8UjKCRRjrS65zFAqjMMYH/AE+lnVgjJ8cyQyAEcMpVYFIVkBdJqr8af42hHOvhw
         QIPDSNHPua/3QrP/TxT0lIc17Wn98wK8ZQGYW6iGgqO153O2NYurve/5ofwf+tgayfyO
         GwBkK7q2ifv7TvIOfe3cyf4vv25hHJsAxvRudE0P+HHQ1VUr4D16muuHczMeVwaGfz7o
         FqDfKQt3cBWJDyMzDe5Nn3hyAeNlRvcJQkCKTFihBXpC0sJHGCAHT3FDlxcV0Ro5cSZ+
         ZVDw==
X-Gm-Message-State: AOAM531Etxp2xNh70jBdW2Bd0KQ3xT4bZ0/00sgZwA1g1GduY7F6zNCi
        9HRXBOFMixK4H1CZy/oV38I=
X-Google-Smtp-Source: ABdhPJzQYZ4fnuE489qbZQIQl0K+5oF3znMk6nDeXk/1Ds2Bt+HoDhIgkiKOGDA8VEfOUtyYaEwomA==
X-Received: by 2002:aa7:8dda:0:b029:1fa:19b3:7ed9 with SMTP id j26-20020aa78dda0000b02901fa19b37ed9mr4198063pfr.32.1615401944168;
        Wed, 10 Mar 2021 10:45:44 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y15sm283777pgi.31.2021.03.10.10.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 10:45:43 -0800 (PST)
Subject: Re: [PATCH net] net: dsa: only unset VLAN filtering when last port
 leaves last VLAN-aware bridge
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210308135509.3040286-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <54bdfa29-3e21-d560-b10f-bed7a8f570ae@gmail.com>
Date:   Wed, 10 Mar 2021 10:45:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210308135509.3040286-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/21 5:55 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> DSA is aware of switches with global VLAN filtering since the blamed
> commit, but it makes a bad decision when multiple bridges are spanning
> the same switch:
> 
> ip link add br0 type bridge vlan_filtering 1
> ip link add br1 type bridge vlan_filtering 1
> ip link set swp2 master br0
> ip link set swp3 master br0
> ip link set swp4 master br1
> ip link set swp5 master br1
> ip link set swp5 nomaster
> ip link set swp4 nomaster
> [138665.939930] sja1105 spi0.1: port 3: dsa_core: VLAN filtering is a global setting
> [138665.947514] DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE
> 
> When all ports leave br1, DSA blindly attempts to disable VLAN filtering
> on the switch, ignoring the fact that br0 still exists and is VLAN-aware
> too. It fails while doing that.
> 
> This patch checks whether any port exists at all and is under a
> VLAN-aware bridge.
> 
> Fixes: d371b7c92d19 ("net: dsa: Unset vlan_filtering when ports leave the bridge")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

This uncovered a bug in the bcm_sf2 driver which failed to set
ds->vlan_filtering_is_global so with that fixed, I was able to verify
that the scenario above would produce the above message and failure, and
with the patch applied this works correctly as expected without
disabling VLAN filtering on br0. When the last port on br0 leaves the
bridge however, VLAN filtering is turned off since there is no more user
requiring it.

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!
--
Florian
