Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BA14BBDCF
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 17:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbiBRQvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 11:51:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbiBRQvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 11:51:32 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF77315A227;
        Fri, 18 Feb 2022 08:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=Pbdl+NjCsDO0eLase/4uSbewdLL/4qAMXdwzMo6Whls=;
        t=1645203076; x=1646412676; b=VFgjVevuBehVn8/VUbGDXhrFktQky9iE0hKW4+oG3j4s/sh
        8yTK1krLGXR7LHqDXRQkbKH4r68Z8wq1gQJUM74w/4/8GLXy1HZxo+F5vUWOTTBUyr9VKEkE1GidP
        KulxujYyI6eiKbOXQenkH6YzPFb1BcpEfZfEB2u2CyiOUqf9hrnHtDQE28H5NaR9U9cukej531OLB
        R9IiLjtoQxVnphFyEMffWpWbHgEhihJ0fFqCofsYZwSVImMfIBH9AKPn0aYdFT9LRWVZO7gIlBLl1
        XkDCiYKzSfX+7GhCX4iqAB/DsucEZtKJ/S8+bb0sOJEBvkHuoKGU0zSrlV2c0iuw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nL6TJ-002j4y-OA;
        Fri, 18 Feb 2022 17:51:05 +0100
Message-ID: <cbc4026aa94ff68e984743ef1666a6dd810c596d.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211: check return of nla_parse_nested
From:   Johannes Berg <johannes@sipsolutions.net>
To:     trix@redhat.com, davem@davemloft.net, kuba@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, cjhuang@codeaurora.org,
        briannorris@chromium.org, kuabhs@chromium.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Date:   Fri, 18 Feb 2022 17:51:04 +0100
In-Reply-To: <20220218163045.3370662-1-trix@redhat.com>
References: <20220218163045.3370662-1-trix@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-02-18 at 08:30 -0800, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this representative problem
> nl80211.c:15426:6: warning: Branch condition evaluates
>   to a garbage value
>   if (!tb[NL80211_SAR_ATTR_TYPE] ||
>        ^~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> tb is set when nla_parse_nested() is successful.
> So check.

Well, it's a bit annoying that we cannot express/check this, but we
already validated that it's going to succeed, through the nested policy:

static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
[...]
        [NL80211_ATTR_SAR_SPEC] = NLA_POLICY_NESTED(sar_policy),


Thus, it cannot actually fail. I suppose in this case checking for
errors doesn't make the code that much worse, but there's isn't really
much point. Maybe a comment would be useful?

johannes
