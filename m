Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339EE692B9D
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 00:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjBJXre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 18:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjBJXrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 18:47:33 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24BC7AA2
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 15:47:32 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id b5so8315801plz.5
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 15:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yvOux52E5DbaWC84jPuO4nUHQ0TNZblI+i2jTa4EFtQ=;
        b=ED8dYO9FNKMIjc/TCRz/NpirWuHWiTRnFNfdsQVxx2FJMVek+p15igeFFuXcpBXiOC
         Y0a+I/8ktLsvo3N5MdhQG37xXQrx30WhEOaTl6+S07YfwDwd7bxXvNesnYzJp+eALuXo
         KUm26Y7UUTPzjXC3YigSUPU2ZEFQyvhYKC6NLXmHB9dOWCDM+zVS8t88EyA/nvZ/QbDK
         8FD2HHMAj8KT15+W5edNMPTzLH5+nKRXdDg4mgYOhHKejxL2iW0ecDLrjngpdxLYu4LP
         J8W0zZa/WSCXNSOByPNry0lATSsomc5uTjI7VP4ZjipR1KOZBz1HUYtsgK0oewTB3pet
         KGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yvOux52E5DbaWC84jPuO4nUHQ0TNZblI+i2jTa4EFtQ=;
        b=rQb8AOjlYAr7RxR0Cg/NRdhkNLsmS+PpwkwQNNKNECXOrmO4f04JSIE8OBD85W6TWE
         y7gOR/q0Z1/Wp+HzLYWvbqbr5+xHekQs+sPFD0+7llWTjpYR0pCb3lHrH7a0CzR+ULvE
         luDox8ohG3vOOYg46vGE3N3F0MkRPsKXB47B2CdwhRUVRshapoa+YBR+NMIrAESiV/Dj
         hMuWK8lRF3JYtHXkz2xevZ6LZcU5+YsNnjfdV3EzSBi9E2l0b7NMfeMmXoIB/3ikqWxd
         xhZ1w5yUmR2dc1DwGue44sX5yl0Q6r4kRmsDt7kTYW8mQANeABbw/7b/f81WAgHQJHgd
         tcLA==
X-Gm-Message-State: AO0yUKWsuBwky48Aj3QP5sxOiEUAf7U80cUP6Z6mAU1Ar+mz+tFiVDBk
        OIl8jAtRn0R1TVv/lKmTw9Vm4A==
X-Google-Smtp-Source: AK7set9RitrimshGarArBisRdiVw5OT6p3mabnFwY8OKzVIC3UbTvCc/t/dpUCvTiH/5rQmO/QGGqQ==
X-Received: by 2002:a17:902:ee89:b0:19a:5a9d:3c with SMTP id a9-20020a170902ee8900b0019a5a9d003cmr82270pld.16.1676072851861;
        Fri, 10 Feb 2023 15:47:31 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c10c00b00189743ed3b6sm3885380pli.64.2023.02.10.15.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 15:47:31 -0800 (PST)
Date:   Fri, 10 Feb 2023 23:47:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Borislav Petkov <bp@alien8.de>,
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
Message-ID: <Y+bXjxUtSf71E5SS@google.com>
References: <4216dea6-d899-aecb-2207-caa2ae7db0e3@intel.com>
 <BYAPR21MB16886D92828BA2CA8D47FEA4D7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aP8rHr6H3LIf/c@google.com>
 <Y+aVFxrE6a6b37XN@zn.tnic>
 <BYAPR21MB16882083E84F20B906E2C847D7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aczIbbQm/ZNunZ@zn.tnic>
 <cb80e102-4b78-1a03-9c32-6450311c0f55@intel.com>
 <Y+auMQ88In7NEc30@google.com>
 <Y+av0SVUHBLCVdWE@google.com>
 <BYAPR21MB168864EF662ABC67B19654CCD7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR21MB168864EF662ABC67B19654CCD7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023, Michael Kelley (LINUX) wrote:
> From: Sean Christopherson <seanjc@google.com> Sent: Friday, February 10, 2023 12:58 PM
> > 
> > On Fri, Feb 10, 2023, Sean Christopherson wrote:
> > > On Fri, Feb 10, 2023, Dave Hansen wrote:
> > > > On 2/10/23 11:36, Borislav Petkov wrote:
> > > > >> One approach is to go with the individual device attributes for now.>> If the list
> > does grow significantly, there will probably be patterns
> > > > >> or groupings that we can't discern now.  We could restructure into
> > > > >> larger buckets at that point based on those patterns/groupings.
> > > > > There's a reason the word "platform" is in cc_platform_has(). Initially
> > > > > we wanted to distinguish attributes of the different platforms. So even
> > > > > if y'all don't like CC_ATTR_PARAVISOR, that is what distinguishes this
> > > > > platform and it *is* one platform.
> > > > >
> > > > > So call it CC_ATTR_SEV_VTOM as it uses that technology or whatever. But
> > > > > call it like the platform, not to mean "I need this functionality".
> > > >
> > > > I can live with that.  There's already a CC_ATTR_GUEST_SEV_SNP, so it
> > > > would at least not be too much of a break from what we already have.
> > >
> > > I'm fine with CC_ATTR_SEV_VTOM, assuming the proposal is to have something like:
> > >
> > > 	static inline bool is_address_range_private(resource_size_t addr)
> > > 	{
> > > 		if (cc_platform_has(CC_ATTR_SEV_VTOM))
> > > 			return is_address_below_vtom(addr);
> > >
> > > 		return false;
> > > 	}
> > >
> > > i.e. not have SEV_VTOM mean "I/O APIC and vTPM are private".  Though I don't see
> > > the point in making it SEV vTOM specific or using a flag.  Despite what any of us
> > > think about TDX paravisors, it's completely doable within the confines of TDX to
> > > have an emulated device reside in the private address space.  E.g. why not
> > > something like this?
> > >
> > > 	static inline bool is_address_range_private(resource_size_t addr)
> > > 	{
> > > 		return addr < cc_platform_private_end;
> > > 	}
> > >
> > > where SEV fills in "cc_platform_private_end" when vTOM is enabled, and TDX does
> > > the same.  Or wrap cc_platform_private_end in a helper, etc.
> > 
> > Gah, forgot that the intent with TDX is to enumerate devices in their legacy
> > address spaces.  So a TDX guest couldn't do this by default, but if/when Hyper-V
> > or some other hypervisor moves I/O APIC, vTPM, etc... into the TCB, the common
> > code would just work and only the hypervisor-specific paravirt code would need
> > to change.
> > 
> > Probably need a more specific name than is_address_range_private() though, e.g.
> > is_mmio_address_range_private()?
> 
> Maybe I'm not understanding what you are proposing, but in an SEV-SNP
> VM using vTOM, devices like the IO-APIC and TPM live at their usual guest
> physical addresses.

Ah, so as the cover letter says, the intent really is to treat vTOM as an
attribute bit.  Sorry, I got confused by Boris's comment:

  : What happens if the next silly HV guest scheme comes along and they do
  : need more and different ones?

Based on that comment, I assumed the proposal to use CC_ATTR_SEV_VTOM was intended
to be a generic range-based thing, but it sounds like that's not the case. 

IMO, using CC_ATTR_SEV_VTOM to infer anything about the state of I/O APIC or vTPM
is wrong.  vTOM as a platform feature effectively says "physical address bit X
controls private vs. shared" (ignoring weird usage of vTOM).  vTOM does not mean
I/O APIC and vTPM are private, that's very much a property of Hyper-V's current
generation of vTOM-based VMs.

Hardcoding this in the guest feels wrong.  Ideally, we would have a way to enumerate
that a device is private/trusted, e.g. through ACPI.  I'm guessing we already
missed the boat on that, so the next best thing is to do something like Michael
originally proposed in this patch and shove the "which devices are private" logic
into hypervisor-specific code, i.e. let Hyper-V figure out how to enumerate to its
guests which devices are shared.

I agree with Boris' comment that a one-off "other encrypted range" is a hack, but
that's just an API problem.  The kernel already has hypervisor specific hooks (and
for SEV-ES even), why not expand that?  That way figuring out which devices are
private is wholly contained in Hyper-V code, at least until there's a generic
solution for enumerating private devices, though that seems unlikely to happen
and will be a happy problem to solve if it does come about.

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a868b76cd3d4..08f65ed439d9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2682,11 +2682,16 @@ static void io_apic_set_fixmap(enum fixed_addresses idx, phys_addr_t phys)
 {
        pgprot_t flags = FIXMAP_PAGE_NOCACHE;
 
-       /*
-        * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
-        * bits, just like normal ioremap():
-        */
-       flags = pgprot_decrypted(flags);
+       if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
+               /*
+               * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
+               * bits, just like normal ioremap():
+               */
+               if (x86_platform.hyper.is_private_mmio(phys))
+                       flags = pgprot_encrypted(flags);
+               else
+                       flags = pgprot_decrypted(flags);
+       }
 
        __set_fixmap(idx, phys, flags);
 }
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 6453fbaedb08..0baec766b921 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -116,6 +116,9 @@ static void __ioremap_check_other(resource_size_t addr, struct ioremap_desc *des
        if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
                return;
 
+       if (x86_platform.hyper.is_private_mmio(addr))
+               desc->flags |= IORES_MAP_ENCRYPTED;
+
        if (!IS_ENABLED(CONFIG_EFI))
                return;
 

