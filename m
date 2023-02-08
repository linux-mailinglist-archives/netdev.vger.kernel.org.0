Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D271168EE1D
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjBHLkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjBHLkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:40:51 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1119545F6F
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:40:49 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id m2so50501645ejb.8
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 03:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iIXaeZqH7rwTvz3iQbJf2AOozbC9/x2LdkOVc1nqhrY=;
        b=gTH6C2butHoioEvUSjCRt029t3jOxGen/zm2bI9Evy509ZnAMhR8UBbGlCIpvRu+uO
         nujXqzNpY9OAacn+3A8IdpSt3BcAdre265B54hcLCBfSFUaS8/X2KUWC1JrXb0W9QJNR
         Mb4lL7jE2zfrSIKMTIqVJMR4gCXI08bvX+5MeL1bdcAXPvMajEc7U/Rgh1ZahfhBN/qt
         87O1y8RRMa/+OO7BKLCl1qqCErS8AQ4xkTTYjfvF0k6ASWJXASatLvp/Otpz7WSGJ28p
         CgZBv/CwA53B2web0LGUYjGe8ISWqfNCcAdencchwMWGKQcxoeqBrjuyBugTqr3qL0MX
         ZqZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iIXaeZqH7rwTvz3iQbJf2AOozbC9/x2LdkOVc1nqhrY=;
        b=ukRPV+gsScAQ+De08dTR9jA8JhyGEKq/hCQZWWJhHDpYKTQBTD5kTYgt2sTc9npNCo
         rHpKy5qw02xnZJRKPiJ9qR4YgOkxFSsEtUrWpv++nDCq6mxaaDRYb9934AKcjNKLtse2
         +imX07pdpZY6P5uiNGhPQHim09RcbiXG3a8yZPNSh1CpoSn+CcKtNBMQ4BW4uKErDrUn
         qrUUTxyff6GY08kZqr2mXeiSC1cS03Oqequg5Ulreep2U0F8PUuELhXIacTXGWXDveOe
         Z1/HeK3U6Ih/qK7g6LmsvVE7jlIiA4U0OIWHhhp7LvnAXuuw0HTjiues9t9adb2t3+Rr
         m1zA==
X-Gm-Message-State: AO0yUKVB73lpnxhZqTzseg63sMKgJrrd+Rwhu4H+BjvaNuJEDS2Q2NL5
        ffLtRm06RDGl9e9RQlc1ubGqnQ==
X-Google-Smtp-Source: AK7set/c/YXyL1SEaO/v949+jgEfvisCf0xMVzADN5t18eEnJ9tTnHDfrU9pxg5ZCYpJCW9Rqixyyw==
X-Received: by 2002:a17:906:fb8a:b0:8af:2191:89a6 with SMTP id lr10-20020a170906fb8a00b008af219189a6mr208878ejb.72.1675856447562;
        Wed, 08 Feb 2023 03:40:47 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id gu19-20020a170906f29300b008a9e585786dsm2068223ejb.64.2023.02.08.03.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 03:40:46 -0800 (PST)
Date:   Wed, 8 Feb 2023 12:40:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <Y+OKPYua5jm7kHz8@nanopsycho>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
 <20230206153603.2801791-2-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230206153603.2801791-2-simon.horman@corigine.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Feb 06, 2023 at 04:36:02PM CET, simon.horman@corigine.com wrote:
>From: Fei Qin <fei.qin@corigine.com>
>
>Multiple physical ports of the same NIC may share the single
>PCI address. In some cases, assigning VFs to different physical
>ports can be demanded, especially under high-traffic scenario.
>Load balancing can be realized in virtualised use¬cases through
>distributing packets between different physical ports with LAGs
>of VFs which are assigned to those physical ports.
>
>This patch adds new attribute "vf_count" to 'devlink port function'
>API which only can be shown and configured under devlink ports
>with flavor "DEVLINK_PORT_FLAVOUR_PHYSICAL".

I have to be missing something. That is the meaning of "assigning VF"
to a physical port? Why there should be any relationship between
physical port and VF other than configured forwarding (using TC for
example)?

This seems very wrong. Preliminary NAK.


>
>e.g.
>$ devlink port show pci/0000:82:00.0/0
>pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical
>port 0 splittable true lanes 4
>    function:
>       vf_count 0
>
>$ devlink port function set pci/0000:82:00.0/0 vf_count 3
>
>$ devlink port show pci/0000:82:00.0/0
>pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical
>port 0 splittable true lanes 4
>    function:
>       vf_count 3
>
>Signed-off-by: Fei Qin <fei.qin@corigine.com>
>Signed-off-by: Simon Horman <simon.horman@corigine.com>
