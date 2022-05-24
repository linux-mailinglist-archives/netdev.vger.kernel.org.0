Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90F4532438
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 09:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbiEXHh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 03:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234236AbiEXHh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 03:37:56 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485E46D4F9
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 00:37:55 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id u27so23589067wru.8
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 00:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kBh4Q11GjjoCmn9oHvVJ+UO224sUnrM4p4PfaUvrWck=;
        b=jU9N4xRdgYZbp3SgzjL/ZGKE2sBYy8lJllpnugwyyxtja/wrdOmUZa277Mj54fesS1
         9haJoxr3ki3XLYosAxZsl2BoobTC/kJL0gN1+ppKLaWm3hez4PTQ+Nl5GDb0jUXHfH8S
         vu6IfZY6eAuSrIzgUxbQx6QHMC8KG7aeFGGjmgYX/n8l/a69bxChPjV3wJD6yRzgbLm3
         oq2dYcE0yv5e/VlLqhxMFdtqDMbbX9Ouwv1FHus/9GzPlIpL7Yz6vX4PvKeWTP3t9COi
         aRT3275i333H1u8VpSSkg4+mqq/01pR5pkYKWqdiuJQNCoYXMyliN4nOISUl3XItGMwx
         LcOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kBh4Q11GjjoCmn9oHvVJ+UO224sUnrM4p4PfaUvrWck=;
        b=UsCDFYzDB1u83RiXhDRSpk8iT5+AwOzg9h3lJ+7Gnd6PfYmQ/Xq+J0lKqKZjR6iEVv
         vAOUWuotwcnH4WPscN52bED2H6s04EhMzCYb8GPZF4ikTh/ZvmdiHZm2oAhSrekNdvM4
         mrwey0BTl9/CiSoQiFMQqBtaxWE/YPGkfClcp2BJyQvPoJYeLE+tgqpbGk7jtL3tU+PZ
         eH+dxshnuFm/xQz110yS2OoI18q11IrpasDgM/q0vmXXQ2jbTkokmv449ygKs/cmNHJq
         tHtezH7UIGq0miypfqgiN/ZCkt9EKkmJaZ6p2dzP9FJ+a+bCTn8nFmlLyq2mB2N2K5VE
         vPMQ==
X-Gm-Message-State: AOAM530BGAfk7+TbRFV7C1cgyVZRRCsujAwWjKfltMfnYN3z5WDtdODd
        PYaSxU1eWMGiKeNzoTMIrWhyygm7mLoAHg==
X-Google-Smtp-Source: ABdhPJwua5YP/u3Cf5c9aMABHdiaJ+jF8V019sUQTwndAnDJSMgOh6/yyQjTdQEQ/9MbDDhgR+JedA==
X-Received: by 2002:a5d:4d8a:0:b0:20d:2ba:7db8 with SMTP id b10-20020a5d4d8a000000b0020d02ba7db8mr22390965wru.624.1653377873865;
        Tue, 24 May 2022 00:37:53 -0700 (PDT)
Received: from 6wind.com ([2a01:e0a:5ac:6460:c065:401d:87eb:9b25])
        by smtp.gmail.com with ESMTPSA id v3-20020adfc5c3000000b0020fcda69b7fsm8257971wrg.109.2022.05.24.00.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 00:37:53 -0700 (PDT)
Date:   Tue, 24 May 2022 09:37:52 +0200
From:   Olivier Matz <olivier.matz@6wind.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, intel-wired-lan@osuosl.org,
        Paul Menzel <pmenzel@molgen.mpg.de>, stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH net v2 0/2] ixgbe: fix promiscuous mode on VF
Message-ID: <YoyLUEk9n1uXHscH@platinum>
References: <20220406095252.22338-1-olivier.matz@6wind.com>
 <YmaLWN0aGIKCzkHP@platinum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmaLWN0aGIKCzkHP@platinum>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Apr 25, 2022 at 01:51:53PM +0200, Olivier Matz wrote:
> Hi,
> 
> On Wed, Apr 06, 2022 at 11:52:50AM +0200, Olivier Matz wrote:
> > These 2 patches fix issues related to the promiscuous mode on VF.
> > 
> > Comments are welcome,
> > Olivier
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> > 
> > Changes since v1:
> > - resend with CC intel-wired-lan
> > - remove CC Hiroshi Shimamoto (address does not exist anymore)
> > 
> > Olivier Matz (2):
> >   ixgbe: fix bcast packets Rx on VF after promisc removal
> >   ixgbe: fix unexpected VLAN Rx in promisc mode on VF
> > 
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Any feedback about this patchset?
> Comments are welcome.

I didn't get feedback for this patchset until now. Am I doing things
correctly? Am I targeting the appropriate mailing lists and people?

Please let me know if I missed something.

Thanks,
Olivier
