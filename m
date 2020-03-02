Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A56B176802
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 00:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgCBXVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 18:21:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbgCBXVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 18:21:01 -0500
Received: from localhost (mobile-166-175-186-165.mycingular.net [166.175.186.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A7D5217F4;
        Mon,  2 Mar 2020 23:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583191259;
        bh=TONpQ9lRLSE0pAUEDQkNAUzRktBAdbRSmJX5TPf4MtM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=F9HmFRV8XUv9Zb1JTcAaZA1jJ5lfthwBmV1C3nRSKVm9QQq/FNCJ8zHL78z+/Hx+c
         nHq5oKp+4x1p0TNv0loPZOy3sWE7JNekJNcsyGeHpeLQaw8Nu394/3adeBUFoLIH69
         egHgJPlnZ1AbWHR2iVOFyNJrNkUKmY/QfVK3ze5M=
Date:   Mon, 2 Mar 2020 17:20:57 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        QLogic-Storage-Upstream@cavium.com,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH 1/5] pci: introduce pci_get_dsn
Message-ID: <20200302232057.GA182308@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccec830f-b932-366a-de61-46159a99b5c9@intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 02, 2020 at 02:33:12PM -0800, Jacob Keller wrote:
> On 3/2/2020 2:25 PM, Bjorn Helgaas wrote:

> >> +int pci_get_dsn(struct pci_dev *dev, u8 dsn[])
> >> +{
> >> +	u32 dword;
> >> +	int pos;
> >> +
> >> +
> >> +	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DSN);
> >> +	if (!pos)
> >> +		return -EOPNOTSUPP;
> >> +
> >> +	/*
> >> +	 * The Device Serial Number is two dwords offset 4 bytes from the
> >> +	 * capability position.
> >> +	 */
> >> +	pos += 4;
> >> +	pci_read_config_dword(dev, pos, &dword);
> >> +	put_unaligned_le32(dword, &dsn[0]);
> >> +	pci_read_config_dword(dev, pos + 4, &dword);
> >> +	put_unaligned_le32(dword, &dsn[4]);
> > 
> > Since the serial number is a 64-bit value, can we just return a u64
> > and let the caller worry about any alignment and byte-order issues?
> > 
> > This would be the only use of asm/unaligned.h in driver/pci, and I
> > don't think DSN should be that special.
> 
> I suppose that's fair, but it ends up leaving most callers having to fix
> this immediately after calling this function.

PCIe doesn't impose any structure on the value; it just says the first
dword is the lower DW and the second is the upper DW.  As long as we
put that together correctly into a u64, I think further interpretation
is caller-specific.

> > I think it's OK if we return 0 if the device doesn't have a DSN
> > capability.  A DSN that actually contains a zero serial number would
> > be dubious at best.
> 
> Hmm. I was trying to match how pre-existing code behaved, based on the
> ice and bnxt drivers.
> 
> By returning 0s, we'd have to then perform a memcmp or something to
> catch it.

Can you just do this:

  dsn = pci_get_dsn(pdev);
  if (!dsn)
    return NULL;

  snprintf(opt_fw_filename, ...);
  return opt_fw_filename;

Or am I missing something?

> >> +	return 0;
> >> +}
> >> +EXPORT_SYMBOL_GPL(pci_get_dsn);
> >> +
> >>  static int __pci_find_next_ht_cap(struct pci_dev *dev, int pos, int ht_cap)
> >>  {
> >>  	int rc, ttl = PCI_FIND_CAP_TTL;
> >> diff --git a/include/linux/pci.h b/include/linux/pci.h
> >> index 3840a541a9de..883562323df3 100644
> >> --- a/include/linux/pci.h
> >> +++ b/include/linux/pci.h
> >> @@ -1045,6 +1045,8 @@ int pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
> >>  int pci_find_next_ht_capability(struct pci_dev *dev, int pos, int ht_cap);
> >>  struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
> >>  
> >> +int pci_get_dsn(struct pci_dev *dev, u8 dsn[]);
> >> +
> >>  struct pci_dev *pci_get_device(unsigned int vendor, unsigned int device,
> >>  			       struct pci_dev *from);
> >>  struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
> >> @@ -1699,6 +1701,9 @@ static inline int pci_find_next_capability(struct pci_dev *dev, u8 post,
> >>  static inline int pci_find_ext_capability(struct pci_dev *dev, int cap)
> >>  { return 0; }
> >>  
> >> +static inline int pci_get_dsn(struct pci_dev *dev, u8 dsn[])
> >> +{ return -EOPNOTSUPP; }
> >> +
> >>  /* Power management related routines */
> >>  static inline int pci_save_state(struct pci_dev *dev) { return 0; }
> >>  static inline void pci_restore_state(struct pci_dev *dev) { }
> >> -- 
> >> 2.25.0.368.g28a2d05eebfb
> >>
