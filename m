Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F2563F26D
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 15:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbiLAOOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 09:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiLAOOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 09:14:53 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5898AAC19D;
        Thu,  1 Dec 2022 06:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=lTV2BHXC3ZsKkFBQoA7IcTTy2HsftGqJfG2uCoNRhRI=;
        t=1669904092; x=1671113692; b=VYaAr1Tp0l8kGI/FeUZsKzrXMe7Hr7OT0No3qW0Lrt2eAaC
        tBf1eWLlpj5fLPVPHIELRCgYbN8nVjpPhOAuZiwNXg8kTC76YPiPHLfoANFaUzj5ez/8fWBkr6PTX
        8IlwWlor3SIppcV8VYt37oD7Jgi3TgNK+ekxILbP6dgMOl+lm8GkhLqqJ+8OWzMa6WEuJNlR6vIV2
        ARYB9onxk3xefHCPKeL/1oDLkEAdSV9Il922xYLNckrRsFTHwBzPjkgwzM2KtU+QLPPiZVhn2yZWZ
        Yupy3Bui+252yRh7n3ePlqOymKiLfC5kFIpy5iL868AXxgoKzB14QsGA/HFiYy+A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1p0kKt-00E5tG-26;
        Thu, 01 Dec 2022 15:14:47 +0100
Message-ID: <a5ac1a2e09096280f56c657e966c728ca8e176a0.camel@sipsolutions.net>
Subject: Re: [PATCH net] wifi: mac80211: fix WARNING in
 ieee80211_link_info_change_notify()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Zhengchao Shao <shaozhengchao@huawei.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     weiyongjun1@huawei.com, yuehaibing@huawei.com
Date:   Thu, 01 Dec 2022 15:14:46 +0100
In-Reply-To: <20221104110856.364410-1-shaozhengchao@huawei.com>
References: <20221104110856.364410-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-11-04 at 19:08 +0800, Zhengchao Shao wrote:
>=20
> The execution process is as follows:
> Thread A:
> ieee80211_open()
>     ieee80211_do_open()
>         drv_add_interface()     //set IEEE80211_SDATA_IN_DRIVER flag
> ...
> cfg80211_shutdown_all_interfaces()
>     ...
>     ieee80211_stop()
>         ieee80211_do_stop()
>             drv_remove_interface() //clear flag
> ...
> nl80211_set_mcast_rate()

How is that possible after the interface is no longer running? That
seems to be the issue? I suppose that should be annotated to not be
allowed?

johannes

