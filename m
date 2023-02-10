Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586D86928B6
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 21:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbjBJUvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 15:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbjBJUvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 15:51:08 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D2E7F82E
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:51:02 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id bx22so6481225pjb.3
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G6ClxDPqqo9XGMX8nibdBrVqKRqBmlDx/QkEPTPhrmI=;
        b=CQBERmQX6UW6aN9ppCfG84ilCLxw0hROZywoezlBpkLDc3CEV63muuePgbkAQ4uUTP
         eVYf0yxkeklltYT638VQVLUGWm1IlB+L0GPDdKLiHtJ2WGGLYu5qt7LaGHGnoriCzhpY
         R+rRH6ybKW9tvY9M0IWhT2J77tmpZgTgfGz4/AjJwGtMfQMpO3Z9MH3hGi7qiajkr+a0
         Y2Jn4OfuyhOTmpuJkEJNnPsE2TTKLu6+AWlepChxd0I9e52F1UgvI/MMVi8hWWHW24z8
         FPaztSxLf0zInUZVGmjknEYg8NwCn/c2YtYGTgPHz05CyujaIUcMVeTONN+TBbui6M5V
         +u4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G6ClxDPqqo9XGMX8nibdBrVqKRqBmlDx/QkEPTPhrmI=;
        b=x9hMVyg2pIsLCTwWKCcqRldRUaxfzWCuPNuUG18lxga7EJDBg0V3gQyGOFa04wOaSS
         fzMH0LkaFSrGVGRdFArMWNZAYnLavJfhICBGxc6dHwtZ4UkzeGU4AzkRsLdXuOsj4l81
         nmrOGMmCQUpjIH2Y8nJe1Yqq0ERTOzMXl/zIgp4vK8BpXSOnZnxUOvvHrrp4j5K/HcMH
         h4u3wn9xbfCiypbXTKe0f66UQlJMgop6ZY2KEdO8f/5cKjpAw0yopDISqsp0shAp62sy
         4fVkzIMQsVczii5XqpWiHHz+PCds+qDyFIoADSk4JVPX4cGYk9k702jK+IMu4y8HLcq+
         lV0A==
X-Gm-Message-State: AO0yUKU5Y1H0Oim1+k6P4aExlO3XNHsV8plHschZgiGki2Zw0DeYHte4
        nRLgEIlY93PQBAv4hzwPRJeQlw==
X-Google-Smtp-Source: AK7set87/K1BTbtqK1YxC0xEr79tEEU7ncmCCfkbuZto381YIZlqqRDqWHnUS/qjJKIZM1QnsMq8jQ==
X-Received: by 2002:a17:902:7c07:b0:198:af50:e4e6 with SMTP id x7-20020a1709027c0700b00198af50e4e6mr48370pll.12.1676062261748;
        Fri, 10 Feb 2023 12:51:01 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p6-20020aa78606000000b005828071bf7asm3698940pfn.22.2023.02.10.12.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 12:51:01 -0800 (PST)
Date:   Fri, 10 Feb 2023 20:50:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Message-ID: <Y+auMQ88In7NEc30@google.com>
References: <Y9FC7Dpzr5Uge/Mi@zn.tnic>
 <BYAPR21MB16883BB6178DDEEA10FD1F1CD7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+JG9+zdSwZlz6FU@zn.tnic>
 <4216dea6-d899-aecb-2207-caa2ae7db0e3@intel.com>
 <BYAPR21MB16886D92828BA2CA8D47FEA4D7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aP8rHr6H3LIf/c@google.com>
 <Y+aVFxrE6a6b37XN@zn.tnic>
 <BYAPR21MB16882083E84F20B906E2C847D7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aczIbbQm/ZNunZ@zn.tnic>
 <cb80e102-4b78-1a03-9c32-6450311c0f55@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb80e102-4b78-1a03-9c32-6450311c0f55@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023, Dave Hansen wrote:
> On 2/10/23 11:36, Borislav Petkov wrote:
> >> One approach is to go with the individual device attributes for now.>> If the list does grow significantly, there will probably be patterns
> >> or groupings that we can't discern now.  We could restructure into
> >> larger buckets at that point based on those patterns/groupings.
> > There's a reason the word "platform" is in cc_platform_has(). Initially
> > we wanted to distinguish attributes of the different platforms. So even
> > if y'all don't like CC_ATTR_PARAVISOR, that is what distinguishes this
> > platform and it *is* one platform.
> > 
> > So call it CC_ATTR_SEV_VTOM as it uses that technology or whatever. But
> > call it like the platform, not to mean "I need this functionality".
> 
> I can live with that.  There's already a CC_ATTR_GUEST_SEV_SNP, so it
> would at least not be too much of a break from what we already have.

I'm fine with CC_ATTR_SEV_VTOM, assuming the proposal is to have something like:

	static inline bool is_address_range_private(resource_size_t addr)
	{
		if (cc_platform_has(CC_ATTR_SEV_VTOM))
			return is_address_below_vtom(addr);

		return false;
	}

i.e. not have SEV_VTOM mean "I/O APIC and vTPM are private".  Though I don't see
the point in making it SEV vTOM specific or using a flag.  Despite what any of us
think about TDX paravisors, it's completely doable within the confines of TDX to
have an emulated device reside in the private address space.  E.g. why not
something like this? 

	static inline bool is_address_range_private(resource_size_t addr)
	{
		return addr < cc_platform_private_end;
	}

where SEV fills in "cc_platform_private_end" when vTOM is enabled, and TDX does
the same.  Or wrap cc_platform_private_end in a helper, etc.
