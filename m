Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9586E260A
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjDNOql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjDNOqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:46:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8503FB;
        Fri, 14 Apr 2023 07:46:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72BE46456A;
        Fri, 14 Apr 2023 14:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51104C433D2;
        Fri, 14 Apr 2023 14:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681483598;
        bh=P29LENUU8RtK91AEGjjBHIhqRST6T4oensoXgJ9R+eI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GxVOkbUuJn6IAnbgJHXTbkppvlx207XD0Z2rQIWbSjeOATpbxl2iysVbWsWE3pGvj
         UUMMq7fikCUxNy4s8Wf+N7t/Y2chjdIvw35vgxFRyGlAgszsNKR93mA3uyJdd0j+H/
         t0/EqGUUCijQqrBE63NDun+NlGJ4ommyZhUz4qExltiCs2I8vJp6wdFcCo3FutkunD
         4bVf1yppAMNrcmi+R2qab2BROR1xNz1KAvDquRKeDyP5ZZdBTYQ24b2Mb98ok5EEwB
         P9qBrx3jc5xFD03gfGwUw6XhWbW8+YJKm+tKU0fM31SGjHKVvAsTLLihF9JA/gwhiq
         Hd1oGyDA0z1oQ==
Date:   Fri, 14 Apr 2023 07:46:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [RFC PATCH v1] ice: add CGU info to devlink info callback
Message-ID: <20230414074637.561010cc@kernel.org>
In-Reply-To: <DM6PR11MB4657EF2201A5E110697C9E129B999@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230412133811.2518336-1-arkadiusz.kubalewski@intel.com>
        <20230412203500.36fb7c36@kernel.org>
        <DM6PR11MB46577E14FE17ADA6D1E74E789B989@DM6PR11MB4657.namprd11.prod.outlook.com>
        <20230413080405.30bbe3bd@kernel.org>
        <DM6PR11MB4657EF2201A5E110697C9E129B999@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 10:04:05 +0000 Kubalewski, Arkadiusz wrote:
> Although I double checked, and it seems I wasn't clear on previous explan=
ation.
> Once FW update is possible with Intel's nvmupdate tools, the devlink FW u=
pdate
> also going to update CGU firmware (part of nvm-flash region), so after al=
l this
> seems a right place for this info.

=F0=9F=91=8D=EF=B8=8F
