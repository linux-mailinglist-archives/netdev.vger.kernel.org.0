Return-Path: <netdev+bounces-11755-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC7CE7344B8
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 05:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4E4128120B
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 03:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5EADEA6;
	Sun, 18 Jun 2023 03:06:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37E4EA1
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 03:06:15 +0000 (UTC)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02616E4D;
	Sat, 17 Jun 2023 20:06:14 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-666e6541c98so1664830b3a.2;
        Sat, 17 Jun 2023 20:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687057573; x=1689649573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TKr/7fFsDyuqeMVJXBiEJIZ7rSj0By3FJTWDssD98XA=;
        b=lKstEJr0z+1iKP4xpUz8l7TJLScBf6OQ5cAk96VrCQSW2xrP/Wl/nmFMHfwxU1gXz8
         VRlgx6CELNkQCSowXdKTi/PW+FB4YpmsmINrf0ePSNjqX8rnZ1vG2IdZzVTrc6rT3YZr
         r3nVq8CwLRfk9eWBPJJrIhoE/UAXxnUPe08nQreVdfavjkWZMIDlN4osA125ECXeEJR4
         oP/p435fCt6By/KA7ZMnGVYESTFOd1zrqhPtHSreDFLqOdHU9f3EiPXIMWASmmO78o3o
         BpxxiRR12yn95prcEwlMyZnDn7YKOkUS0JF31+HozWbsUH7Y6cZJvxQZeQDfe31Nxeyq
         ikAA==
X-Gm-Message-State: AC+VfDzYuQLFHoCYGGyTksjsQjCwsERpTdjHMZQ1gaBmrx+S6jQga0Al
	i0U+6VLAWmanjxaLIsqami8=
X-Google-Smtp-Source: ACHHUZ74QrQ86X1lYZ850oqc82Io3H167wR3MfIR6qT0HuQK7NUlA3TCEIzguXToHF7OYlQIYKqjDg==
X-Received: by 2002:a05:6a00:14d2:b0:64f:6c01:d580 with SMTP id w18-20020a056a0014d200b0064f6c01d580mr9104380pfu.14.1687057573305;
        Sat, 17 Jun 2023 20:06:13 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id k16-20020aa792d0000000b00665a76a8cfasm9539488pfa.194.2023.06.17.20.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jun 2023 20:06:12 -0700 (PDT)
Date: Sun, 18 Jun 2023 03:06:11 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Dexuan Cui <decui@microsoft.com>
Cc: bhelgaas@google.com, davem@davemloft.net, edumazet@google.com,
	haiyangz@microsoft.com, jakeo@microsoft.com, kuba@kernel.org,
	kw@linux.com, kys@microsoft.com, leon@kernel.org,
	linux-pci@vger.kernel.org, lpieralisi@kernel.org,
	mikelley@microsoft.com, pabeni@redhat.com, robh@kernel.org,
	saeedm@nvidia.com, wei.liu@kernel.org, longli@microsoft.com,
	boqun.feng@gmail.com, ssengar@microsoft.com, helgaas@kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	josete@microsoft.com, simon.horman@corigine.com
Subject: Re: [PATCH v4 0/5] pci-hyperv: Fix race condition bugs for fast
 device hotplug
Message-ID: <ZI50o1XBQbRL5Hlk@liuwe-devbox-debian-v2>
References: <20230615044451.5580-1-decui@microsoft.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615044451.5580-1-decui@microsoft.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 09:44:46PM -0700, Dexuan Cui wrote:
> Before the guest finishes probing a device, the host may be already starting
> to remove the device. Currently there are multiple race condition bugs in the
> pci-hyperv driver, which can cause the guest to panic.  The patchset fixes
> the crashes.
> 
> The patchset also does some cleanup work: patch 3 removes the useless
> hv_pcichild_state, and patch 4 reverts an old patch which is not really
> useful (without patch 4, it would be hard to make patch 5 clean).
> 
> Patch 6 in v3 is dropped for now since it's a feature rather than a fix.
> Patch 6 will be split into two patches as suggested by Lorenzo and will be
> posted after the 5 patches are accepted first.
> 
> The v4 addressed Lorenzo's comments and added Lorenzo' Acks to patch
> 1, 3 and 5.
> 
> The v4 is based on v6.4-rc6, and can apply cleanly to the Hyper-V tree's
> hyperv-fixes branch.
> 
> The patchset is also availsble in my github branch:
> https://github.com/dcui/tdx/commits/decui/vpci/v6.4-rc6-vpci-v4
> 
> FYI, v3 can be found here:
> https://lwn.net/ml/linux-kernel/20230420024037.5921-1-decui@microsoft.com/
> 
> Please review. Thanks!
> 
> 
> Dexuan Cui (5):
>   PCI: hv: Fix a race condition bug in hv_pci_query_relations()
>   PCI: hv: Fix a race condition in hv_irq_unmask() that can cause panic
>   PCI: hv: Remove the useless hv_pcichild_state from struct hv_pci_dev
>   Revert "PCI: hv: Fix a timing issue which causes kdump to fail
>     occasionally"
>   PCI: hv: Add a per-bus mutex state_lock

Applied to hyperv-fixes. Thanks.

