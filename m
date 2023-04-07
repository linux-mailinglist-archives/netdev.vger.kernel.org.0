Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D129F6DAEED
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 16:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjDGOoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 10:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjDGOog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 10:44:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD98E53
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 07:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67376650C6
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 14:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50459C433D2;
        Fri,  7 Apr 2023 14:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680878674;
        bh=XQKwqTpBE8jyS5Gw96ZMyiMjhR8SI6VwHoYuEx+vyFM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ukjNCeGRh2cMS+ls01KEVm54awqwVWHa5XVcCcr12Z9LsJ+WKzDpOgXvkSVxPgPkt
         WCAd2/gVbgKy0Tj4WHriQJZfyYY5wDIiE/DP3a8nT1Bw6WzLF+3wRWixEQMTZ7ArVp
         7ZcjQfPaVa+StRnviY7o+sD/jaTKrmDrfzp6P3GfvRNtWyxURJ1ZbrrYnuYxCywH/K
         +uRbRSBozKK5TPsLE5FWyEf81dWILa/C9CpXluykDlthvWns6wQWgW8sTTSjkl41bw
         ZVt2SHadZC9hZPB3ai2ZobPbKcLYmaASnIwQ/kTNlzwYqlFFt987w7HTBJjzW8O47m
         KSTBnRclzSTkQ==
Date:   Fri, 7 Apr 2023 07:44:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, thomas.petazzoni@bootlin.com,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <20230407074432.1a2c4c26@kernel.org>
In-Reply-To: <20230407072615.1891cf07@kernel.org>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
        <20230406173308.401924-3-kory.maincent@bootlin.com>
        <20230406184646.0c7c2ab1@kernel.org>
        <20230407105857.1b11a000@kmaincent-XPS-13-7390>
        <20230407072615.1891cf07@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Apr 2023 07:26:15 -0700 Jakub Kicinski wrote:
> > Ok I will take look.
> > Seems broken on net-next:
> > ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/ethtool.yaml --do rings-get --json '{"header":{"dev-index": 18}}'
> > Traceback (most recent call last):
> >   File "./tools/net/ynl/cli.py", line 52, in <module>
> >     main()
> >   File "./tools/net/ynl/cli.py", line 31, in main
> >     ynl = YnlFamily(args.spec, args.schema)
> >   File "/home/kmaincent/Documents/linux/tools/net/ynl/lib/ynl.py", line 361, in __init__
> >     self.family = GenlFamily(self.yaml['name'])
> >   File "/home/kmaincent/Documents/linux/tools/net/ynl/lib/ynl.py", line 331, in __init__
> >     self.genl_family = genl_family_name_to_id[family_name]
> > KeyError: 'ethtool'  
> 
> IIRC this usually means ethtool netlink is not selected by you Kconfig.
> I should add a clearer error for that I guess.
> Booting net-next now, I'll get back to you with a confirmation.

Yeah, works here. FWIW if you want to use it on the VM / remote host
you just need to copy over a couple of dirs:

$ scp -r tools/net/ynl/ $bla:~/
$ scp -r Documentation/netlink/ $bla:~/
$ ssh $bla
bla$ dnf install python-yaml
bla$ ./ynl/cli.py \
	--no-schema \
	--spec netlink/specs/ethtool.yaml \
	--do rings-get \
	--json '{"header":{"dev-index": 2}}'
