Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4694FB77A
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 11:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344397AbiDKJaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 05:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235101AbiDKJaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 05:30:00 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592EF3299F;
        Mon, 11 Apr 2022 02:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=JA9mOJWzTolCXQKQvJN/92K8GCFv6ef6QsNhTck14oM=;
        t=1649669266; x=1650878866; b=MLIIurGoCjTAzw5Os1bkiaLE/VxuksQ/MR1LJORSxhe7q9M
        T+Xi2v6wQ4WUzgsawMUkTSJf8zUj7SKO5OLUVFKAU8sv//L3dQTM0MIlte6vbHupUO88Z4ILuFGyi
        WH89ld2rACSd4Fr4z1l7EP3b7EDWEigCcKjyOGfxO5zWmPkKL0qvuqiKqhOtl2V1aMDq/NwZqmKCx
        u/wkReEWr8Xfyr+tdwA3L53DZzVIpb4nWlz1s7/yWf19dNP9uRMXTuEvhLdQjhkvJlyUsA7v9Uvvh
        +WjR6W6VflBjQ/sT8HNW/G7nVuRskTEYgvidM6m6X7sLnbVDOB8uMT2JPaZsRUeg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ndqKP-008Duy-GT;
        Mon, 11 Apr 2022 11:27:21 +0200
Message-ID: <eb5873b4afeee8a7e183a9b1f2e6af461bf7f69f.camel@sipsolutions.net>
Subject: Re: [nl80211]  584f2e43bb: hwsim.ap_country.fail
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Lee Jones <lee.jones@linaro.org>,
        kernel test robot <oliver.sang@intel.com>
Cc:     0day robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 11 Apr 2022 11:27:20 +0200
In-Reply-To: <YlP0A+PurZl39sUG@google.com>
References: <20220401105046.1952815-1-lee.jones@linaro.org>
         <20220405091420.GD17553@xsang-OptiPlex-9020> <YlP0A+PurZl39sUG@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-04-11 at 10:25 +0100, Lee Jones wrote:
> So what exactly happened here?  What does this failure tell us?

Probably nothing.

> Is the LKP test broken or did I overlook something in the kernel
> patch?

I think the test is just randomly fluking out.

> How does LKP make use of NL80211_ATTR_REG_ALPHA2?
> 
> I'm struggling to find any mention of 'hostapd.py' or 'ap_country' in
> LKP [0].  Are these benchmarks bespoke add-ons? 
> 

it's running the tests from hostap:
https://w1.fi/cgit/hostap/tree/tests/hwsim

Anyway, I think we'd better fix the issue like this:

-       [NL80211_ATTR_REG_ALPHA2] = { .type = NLA_STRING, .len = 2 },
+       /* allow 3 for NUL-termination, we used to declare this NLA_STRING */
+       [NL80211_ATTR_REG_ALPHA2] = NLA_POLICY_RANGE(NLA_BINARY, 2, 3),


What do you think?

johannes
