Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC433546756
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 15:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236985AbiFJN0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 09:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiFJN0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 09:26:00 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685FC8CB36;
        Fri, 10 Jun 2022 06:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=/SmzHm2SiyCKPEGhx/85VV7/8vei9NgvWmD9d3PyooE=;
        t=1654867558; x=1656077158; b=cTmycZAeIa7CYmfSg4u9WMQM6H/xxzhkYhZ+ene4cVXeocP
        Q597hNd7CgDgfG+oxqbJc1QMwTcqyOO1/vOqlfslyTk3siVgCzjBbFNABntxNUpqoA0OfdaMOt3HI
        CFkMFxsCfzJLd/3gkPMrsWN8rMgBdKJKXnUjrsXdhVoLNoAJBwcOy3xXLj/0T09dHu+26c5fMRAas
        5pJAOz1FgWEc3PCLcyopImdJ4Thz4P2RDSIoec8TfTvEG9/8DCWNIsVa2rbAN+yhDabJ7//ZAvQ34
        UKiQ7OwacaX2uKCCg+eO5JOkdzRBE1DlIqzGi5B3CFTggD42j1Suh6n/wb6xlpUg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nzedz-001VLK-5i;
        Fri, 10 Jun 2022 15:25:43 +0200
Message-ID: <a74c86e2d6a7272d206ba44e40d69f48a25be4c1.camel@sipsolutions.net>
Subject: Re: [PATCH v6 1/2] devcoredump: remove the useless gfp_t parameter
 in dev_coredumpv and dev_coredumpm
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, briannorris@chromium.org
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, rafael@kernel.org
Date:   Fri, 10 Jun 2022 15:25:42 +0200
In-Reply-To: <df72af3b1862bac7d8e793d1f3931857d3779dfd.1654569290.git.duoming@zju.edu.cn>
References: <cover.1654569290.git.duoming@zju.edu.cn>
         <df72af3b1862bac7d8e793d1f3931857d3779dfd.1654569290.git.duoming@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-06-07 at 11:26 +0800, Duoming Zhou wrote:
> The dev_coredumpv() and dev_coredumpm() could not be used in atomic
> context, because they call kvasprintf_const() and kstrdup() with
> GFP_KERNEL parameter. The process is shown below:
>=20
> dev_coredumpv(.., gfp_t gfp)
>   dev_coredumpm(.., gfp_t gfp)
>     dev_set_name
>       kobject_set_name_vargs
>         kvasprintf_const(GFP_KERNEL, ...); //may sleep
>           kstrdup(s, GFP_KERNEL); //may sleep
>=20
> This patch removes gfp_t parameter of dev_coredumpv() and dev_coredumpm()
> and changes the gfp_t parameter of kzalloc() in dev_coredumpm() to
> GFP_KERNEL in order to show they could not be used in atomic context.
>=20
> Fixes: 833c95456a70 ("device coredump: add new device coredump class")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Sorry I've been buried in WiFi 7 (and kind of still am...)

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes
