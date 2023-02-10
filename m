Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C3F6928D1
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 21:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbjBJU6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 15:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbjBJU57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 15:57:59 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DFB18B1E
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:57:58 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so6711640pjb.5
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=evdRb0y0uW0suzf6IqaYt5x7djfotbgzG0ewIjt0Uk8=;
        b=KUT+l2F2GWE7igSYQ8d5+p5+59DtVXpCEXbLlVmc96yZz0C6BTvOrxsmTe+OBsGL6s
         y2rzOIBMtqUvWwibc6YD8yAi5yQL/cH6XRbNvg4K7cDiXdcIFRxcLSduB35wUWXXA0VJ
         UeK9Fr3MnD+UOG5bxYvcENuScn2VK2MbwHDh6DLWlTMMB6ENfQqUGQCX/ex0dNBaX4/L
         Vh+BtiM/GbqdCb8E9zZUPWET+0t1LsXdZfKblrGrFj3BpftIY518+n8kbXbPsSi8YbwV
         /d3USSewKz7NLQ6A/T63dPWA2RxNmCM816H+HjOkO44vyORTTbVJHwxomoZAon+9gPk5
         VCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=evdRb0y0uW0suzf6IqaYt5x7djfotbgzG0ewIjt0Uk8=;
        b=1xicndI/+CG387RpGrGwiHIJ2A4WYQ7QVwg3z7WTaOXJ6yf45PYYmQjjZwb7OZy67f
         FyQ5kKgMBFQYsJrqufbYPHhZVcHk7kosU2TXzUVcLyHlKekQP3wBU43saygAc+Iht9pp
         rqXMhrC3Eb1Rm/TW7uGNv7aSPZAayDdRjvQ2GIEouq597a3/SGDA4GWiBPcLugMCBSV0
         o18Sd9WKEojQNj3S0c0DwqLIluszTUd9zn4y7RzA6Bxo4Op2dj68V2yvq6/kaH6lzYmt
         Oczfen0oFil6ixpwYxwoepk8oBShgbimNOx5DXhJzWC/F2K9fKraj1SjroJRVfhzM5l5
         snZg==
X-Gm-Message-State: AO0yUKWFq6E4zfYlquzsX6gFcHgJqwGc0eDOiNq2YLxLMhiV82JUB4Xd
        Adf6l25/om3DpgQt+FD5zkGw3Q==
X-Google-Smtp-Source: AK7set9CwV4ClXZtXo/ecYginhuJqO7iCZWxx36BetrGYm8vH3+HGalmqFIH3VMl3TsAt45IiN7jgw==
X-Received: by 2002:a17:903:111:b0:198:af4f:de12 with SMTP id y17-20020a170903011100b00198af4fde12mr42392plc.18.1676062677683;
        Fri, 10 Feb 2023 12:57:57 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ms16-20020a17090b235000b00233864f21a7sm2070323pjb.51.2023.02.10.12.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 12:57:57 -0800 (PST)
Date:   Fri, 10 Feb 2023 20:57:53 +0000
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
Message-ID: <Y+av0SVUHBLCVdWE@google.com>
References: <BYAPR21MB16883BB6178DDEEA10FD1F1CD7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+JG9+zdSwZlz6FU@zn.tnic>
 <4216dea6-d899-aecb-2207-caa2ae7db0e3@intel.com>
 <BYAPR21MB16886D92828BA2CA8D47FEA4D7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aP8rHr6H3LIf/c@google.com>
 <Y+aVFxrE6a6b37XN@zn.tnic>
 <BYAPR21MB16882083E84F20B906E2C847D7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aczIbbQm/ZNunZ@zn.tnic>
 <cb80e102-4b78-1a03-9c32-6450311c0f55@intel.com>
 <Y+auMQ88In7NEc30@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+auMQ88In7NEc30@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023, Sean Christopherson wrote:
> On Fri, Feb 10, 2023, Dave Hansen wrote:
> > On 2/10/23 11:36, Borislav Petkov wrote:
> > >> One approach is to go with the individual device attributes for now.>> If the list does grow significantly, there will probably be patterns
> > >> or groupings that we can't discern now.  We could restructure into
> > >> larger buckets at that point based on those patterns/groupings.
> > > There's a reason the word "platform" is in cc_platform_has(). Initially
> > > we wanted to distinguish attributes of the different platforms. So even
> > > if y'all don't like CC_ATTR_PARAVISOR, that is what distinguishes this
> > > platform and it *is* one platform.
> > > 
> > > So call it CC_ATTR_SEV_VTOM as it uses that technology or whatever. But
> > > call it like the platform, not to mean "I need this functionality".
> > 
> > I can live with that.  There's already a CC_ATTR_GUEST_SEV_SNP, so it
> > would at least not be too much of a break from what we already have.
> 
> I'm fine with CC_ATTR_SEV_VTOM, assuming the proposal is to have something like:
> 
> 	static inline bool is_address_range_private(resource_size_t addr)
> 	{
> 		if (cc_platform_has(CC_ATTR_SEV_VTOM))
> 			return is_address_below_vtom(addr);
> 
> 		return false;
> 	}
> 
> i.e. not have SEV_VTOM mean "I/O APIC and vTPM are private".  Though I don't see
> the point in making it SEV vTOM specific or using a flag.  Despite what any of us
> think about TDX paravisors, it's completely doable within the confines of TDX to
> have an emulated device reside in the private address space.  E.g. why not
> something like this? 
> 
> 	static inline bool is_address_range_private(resource_size_t addr)
> 	{
> 		return addr < cc_platform_private_end;
> 	}
> 
> where SEV fills in "cc_platform_private_end" when vTOM is enabled, and TDX does
> the same.  Or wrap cc_platform_private_end in a helper, etc.

Gah, forgot that the intent with TDX is to enumerate devices in their legacy
address spaces.  So a TDX guest couldn't do this by default, but if/when Hyper-V
or some other hypervisor moves I/O APIC, vTPM, etc... into the TCB, the common
code would just work and only the hypervisor-specific paravirt code would need
to change.

Probably need a more specific name than is_address_range_private() though, e.g.
is_mmio_address_range_private()?
