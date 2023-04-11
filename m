Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678B46DD803
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 12:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjDKKff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 06:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDKKfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 06:35:34 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC8CE54;
        Tue, 11 Apr 2023 03:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=gZa0B6ArD7nwh7im7KT16C5LGufLTiW26chx7Mq7usk=;
        t=1681209333; x=1682418933; b=POj2mnBfvF5kdfMEnTeQDhFNrx9CUfkacqEG/pvtjEugF/r
        YnXuShO2Sm+Hrt/Qqy948WhiEMvoTWKpZRc/ddmyYmK9s1fZnmbZ4HOjCMdrjvc3fBbPJTkvmLtk8
        jujQRrOCuDaSlvntKHxDYYzgAHKhFei5bm2T0uc+0Y4E4NUcKNrt59RUwe4sfnqbFFMxW1ATfFpfp
        gROyluqB4aKgAaxkL4yIKSCcnlal8ou0rO1XlLCSCcTxlfyr4jWNs+riSS5wBxiqrGgR7XljyJtBE
        SPOGmQdGa4ExKxJ1NsOuqjyCTmZeLrh2C3FjIlmt5lW4jkySGMNxhFhIOL+YBmQA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pmBLJ-00CgdY-2o;
        Tue, 11 Apr 2023 12:35:17 +0200
Message-ID: <0e155b9612bef2c102a4ef5002c25a7ce5a2435e.camel@sipsolutions.net>
Subject: Re: [PATCH v3] net: mac80211: Add NULL checks for sta->sdata
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jia-Ju Bai <baijiaju@buaa.edu.cn>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        simon.horman@corigine.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 11 Apr 2023 12:35:16 +0200
In-Reply-To: <20230404124734.201011-1-baijiaju@buaa.edu.cn>
References: <20230404124734.201011-1-baijiaju@buaa.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-04-04 at 20:47 +0800, Jia-Ju Bai wrote:
> In a previous commit 69403bad97aa ("wifi: mac80211: sdata can be NULL
> during AMPDU start"), sta->sdata can be NULL, and thus it should be
> checked before being used.

Right.

> However, in the same call stack, sta->sdata is also used in the
> following functions:
>=20

Fun, guess we should fix that too then.

Honestly though, I don't think this patch is the right way of going
about it. It seems that instead we should expand the checks in the
previous patch - see how it's talking about a race, and we don't really
want or need to handle aggregation for a station that's being removed.

So I think the better way to fix it would be to prevent the race more
clearly, though off the top of my head I'm not sure how we'd do that.

johannes
