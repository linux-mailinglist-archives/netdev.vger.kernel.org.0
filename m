Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E27B3AABA4
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 21:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389288AbfIETCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 15:02:19 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44988 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388876AbfIETCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 15:02:19 -0400
Received: by mail-ed1-f68.google.com with SMTP id p2so2570566edx.11;
        Thu, 05 Sep 2019 12:02:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v4l9+uLQJWURusV4drj/K/JT9G0Yx+NFjnv0KyB59Ic=;
        b=PnvOvkJDFNg+acQrpzjam3LrhWcZUIbSV03EXhQ9SgNbgVR/AqtMhjbwuZ8GDXBab3
         ouBdHhiZCSRrmT2gHqDdanSS6HIFRf/nXPryS9H8+kvwoMp2PAnGnDO/+cJvgywYy2Za
         JeFkKSzL5kUSupSwMvaxqd82u/l1fPg2nzvaKVrbzCG14Q20EaOycbVhfaizWgyJJB5K
         m9FjaMKFN6JUSiJi+bZA1mdxIrlUBOFg/tZowzXyIs3eWkJWbnuwRnHKYQumEFbSZZUg
         f2ERshrDuYFC6s8QkTCd8ZjXuBljgZkySCK/glC+0VyfDHo6MtSQX39kYHAT5Ffbt4K0
         Z1gA==
X-Gm-Message-State: APjAAAUgp9GMIoRuVgBWGV8XOfl7FXGalJGgHLLokoRsw03bJoW/bIi3
        yHqTZQnrW1Zq0jG6uRSSc5G5O671j/o=
X-Google-Smtp-Source: APXvYqxzTd47MqlgRCViKZrBRfYIigl7s3wz0sbueSZHBfhnmYPyF1bujYRjHD25yQvX/uZoFR+sVg==
X-Received: by 2002:a17:906:4e12:: with SMTP id z18mr4200348eju.187.1567710136067;
        Thu, 05 Sep 2019 12:02:16 -0700 (PDT)
Received: from [10.68.32.192] (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.gmail.com with ESMTPSA id t22sm520533edd.79.2019.09.05.12.02.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Sep 2019 12:02:15 -0700 (PDT)
Subject: Re: [PATCH v2 00/10] Add definition for the number of standard PCI
 BARs
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Sebastian Ott <sebott@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Peter Jones <pjones@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>, kvm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, linux-s390@vger.kernel.org
References: <20190816092437.31846-1-efremov@linux.com>
 <20190816105128.GD14111@e119886-lin.cambridge.arm.com>
From:   Denis Efremov <efremov@linux.com>
Message-ID: <5d8cdc6b-f8c9-c3f1-e11d-13b3a7eb5b26@linux.com>
Date:   Thu, 5 Sep 2019 22:02:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <20190816105128.GD14111@e119886-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16.08.2019 13:51, Andrew Murray wrote:
> On Fri, Aug 16, 2019 at 12:24:27PM +0300, Denis Efremov wrote:
>> Code that iterates over all standard PCI BARs typically uses
>> PCI_STD_RESOURCE_END, but this is error-prone because it requires
>> "i <= PCI_STD_RESOURCE_END" rather than something like
>> "i < PCI_STD_NUM_BARS". We could add such a definition and use it the same
>> way PCI_SRIOV_NUM_BARS is used. There is already the definition
>> PCI_BAR_COUNT for s390 only. Thus, this patchset introduces it globally.
>>
>> Changes in v2:
>>   - Reverse checks in pci_iomap_range,pci_iomap_wc_range.
>>   - Refactor loops in vfio_pci to keep PCI_STD_RESOURCES.
>>   - Add 2 new patches to replace the magic constant with new define.
>>   - Split net patch in v1 to separate stmmac and dwc-xlgmac patches.
>>
>> Denis Efremov (10):
>>   PCI: Add define for the number of standard PCI BARs
>>   s390/pci: Loop using PCI_STD_NUM_BARS
>>   x86/PCI: Loop using PCI_STD_NUM_BARS
>>   stmmac: pci: Loop using PCI_STD_NUM_BARS
>>   net: dwc-xlgmac: Loop using PCI_STD_NUM_BARS
>>   rapidio/tsi721: Loop using PCI_STD_NUM_BARS
>>   efifb: Loop using PCI_STD_NUM_BARS
>>   vfio_pci: Loop using PCI_STD_NUM_BARS
>>   PCI: hv: Use PCI_STD_NUM_BARS
>>   PCI: Use PCI_STD_NUM_BARS
>>
>>  arch/s390/include/asm/pci.h                      |  5 +----
>>  arch/s390/include/asm/pci_clp.h                  |  6 +++---
>>  arch/s390/pci/pci.c                              | 16 ++++++++--------
>>  arch/s390/pci/pci_clp.c                          |  6 +++---
>>  arch/x86/pci/common.c                            |  2 +-
>>  drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c |  4 ++--
>>  drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c   |  2 +-
>>  drivers/pci/controller/pci-hyperv.c              | 10 +++++-----
>>  drivers/pci/pci.c                                | 11 ++++++-----
>>  drivers/pci/quirks.c                             |  4 ++--
>>  drivers/rapidio/devices/tsi721.c                 |  2 +-
>>  drivers/vfio/pci/vfio_pci.c                      | 11 +++++++----
>>  drivers/vfio/pci/vfio_pci_config.c               | 10 ++++++----
>>  drivers/vfio/pci/vfio_pci_private.h              |  4 ++--
>>  drivers/video/fbdev/efifb.c                      |  2 +-
>>  include/linux/pci.h                              |  2 +-
>>  include/uapi/linux/pci_regs.h                    |  1 +
>>  17 files changed, 51 insertions(+), 47 deletions(-)
> 
> I've come across a few more places where this change can be made. There
> may be multiple instances in the same file, but only the first is shown
> below:
> 
> drivers/misc/pci_endpoint_test.c:       for (bar = BAR_0; bar <= BAR_5; bar++) {
> drivers/net/ethernet/intel/e1000/e1000_main.c:          for (i = BAR_1; i <= BAR_5; i++) {
> drivers/net/ethernet/intel/ixgb/ixgb_main.c:    for (i = BAR_1; i <= BAR_5; i++) {
> drivers/pci/controller/dwc/pci-dra7xx.c:        for (bar = BAR_0; bar <= BAR_5; bar++)
> drivers/pci/controller/dwc/pci-layerscape-ep.c: for (bar = BAR_0; bar <= BAR_5; bar++)
> drivers/pci/controller/dwc/pcie-artpec6.c:      for (bar = BAR_0; bar <= BAR_5; bar++)
> drivers/pci/controller/dwc/pcie-designware-plat.c:      for (bar = BAR_0; bar <= BAR_5; bar++)
> drivers/pci/endpoint/functions/pci-epf-test.c:  for (bar = BAR_0; bar <= BAR_5; bar++) {
> include/linux/pci-epc.h:        u64     bar_fixed_size[BAR_5 + 1];
> drivers/scsi/pm8001/pm8001_hwi.c:       for (bar = 0; bar < 6; bar++) {
> drivers/scsi/pm8001/pm8001_init.c:      for (bar = 0; bar < 6; bar++) {
> drivers/ata/sata_nv.c:  for (bar = 0; bar < 6; bar++)
> drivers/video/fbdev/core/fbmem.c:       for (idx = 0, bar = 0; bar < PCI_ROM_RESOURCE; bar++) {
> drivers/staging/gasket/gasket_core.c:   for (i = 0; i < GASKET_NUM_BARS; i++) {
> drivers/tty/serial/8250/8250_pci.c:     for (i = 0; i < PCI_NUM_BAR_RESOURCES; i++) { <-----------
> 
> It looks like BARs are often iterated with PCI_NUM_BAR_RESOURCES, there
> are a load of these too found with:
> 
> git grep PCI_ROM_RESOURCE | grep "< "
> 
> I'm happy to share patches if preferred.
> 

I'm not sure about lib/devres.c
265:#define PCIM_IOMAP_MAX      PCI_ROM_RESOURCE
268:    void __iomem *table[PCIM_IOMAP_MAX];
277:    for (i = 0; i < PCIM_IOMAP_MAX; i++)
324:    BUG_ON(bar >= PCIM_IOMAP_MAX);
352:    for (i = 0; i < PCIM_IOMAP_MAX; i++)
455:    for (i = 0; i < PCIM_IOMAP_MAX; i++) {

Is it worth changing?
#define PCIM_IOMAP_MAX  PCI_STD_NUM_BARS

Thanks,
Denis
