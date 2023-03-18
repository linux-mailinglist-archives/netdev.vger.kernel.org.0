Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A3B6BF7E5
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 06:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjCRFBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 01:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCRFBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 01:01:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAED5F220;
        Fri, 17 Mar 2023 22:01:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D917660A48;
        Sat, 18 Mar 2023 05:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB78EC433EF;
        Sat, 18 Mar 2023 05:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679115711;
        bh=PxRIo0A7tcGbDa1aanq/YotvsdvguxNkjmPcdBjdkOg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=owddyFk0m4sPaEwZF9bUd2HEbdOWAOuY2XplpNs8Q/BMOdQjDMkA+WbQptYuTucWE
         vvPQIbuFUtw6d2ulFT6brKULK/8IrybBLiblYipz6PY3zroDHybU11580QRrFdyy5R
         67ik/Pi8eiJH1lN0Rs6L6G8l13iPOrRNRpCvscCpaYuYmA69a0CeaZmii3HWSpnL24
         sAfqVOfcoh4Mt1O0K9ZAvd7ZvMHTvD1SVWBd8z7vIv7yjhc3ntYzzAe/BbBvVLUW+z
         dg6iJgfv/pEMaXAWyNQsu0A4SiSD6UiOcgAsxZgEQkoJcpDlQCFH8kwtp3bBfP1ol6
         swGv3j/psGing==
Date:   Fri, 17 Mar 2023 22:01:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Vadim Fedorenko <vadfed@meta.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH RFC v6 0/6] Create common DPLL/clock configuration API
Message-ID: <20230317220149.643b6d8f@kernel.org>
In-Reply-To: <ZBSQ3MFzQSBfGH7O@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
        <ZA8VAzAhaXK3hg04@nanopsycho>
        <eb738303-b95c-408c-448d-0ebf983df01f@linux.dev>
        <ZBSQ3MFzQSBfGH7O@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 17:10:04 +0100 Jiri Pirko wrote:
> Interesting, is this working for you?
> I'm experiencing some issue with cmd value. Example:
> ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do device-get --json '{"id": 0}'
> this should send DPLL_CMD_DEVICE_GET which is 1.
> In kernel genl_family_rcv_msg() the hdr->cmd is 2
> Any idea what might be wrong?

I changed the default value for the first element of an attribute set
from 0 to 1 to avoid having to add all those (pointless?)

+      -
+        name: unspec
+        doc: unspecified value

at the start. So delete those or explicitly set them to value: 0.

See commit ad4fafcde5bc ("tools: ynl: use 1 as the default for first
entry in attrs/ops").
