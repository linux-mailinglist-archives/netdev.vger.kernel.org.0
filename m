Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D6A2EEC11
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 04:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbhAHD4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 22:56:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33486 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726823AbhAHD4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 22:56:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610078090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H46Bba+ZfWfjh5ok4yqGmIl0SZHI9WZnCNr0vQpTg94=;
        b=RZi4dEdhHZ/1QXY2jRlI6Hl+Iz/OrL/DkBf3UrgzC9uY/TGaaiD7aUV4fyGX7SgbVE2X9N
        LptauvkX4ZRjCvzLfexFapFJ3eXmpi6hXFEN0LmZ4HfDQQ24AOE008J0TqDjAw3gevwrsy
        YVSEiG1qm9/qzJvg1OJRk7b8MnQ427c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-wwADCsElP-6HecDfBEnbTA-1; Thu, 07 Jan 2021 22:54:46 -0500
X-MC-Unique: wwADCsElP-6HecDfBEnbTA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C3E5800D55;
        Fri,  8 Jan 2021 03:54:44 +0000 (UTC)
Received: from [10.3.112.139] (ovpn-112-139.phx2.redhat.com [10.3.112.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30E7160BF1;
        Fri,  8 Jan 2021 03:54:39 +0000 (UTC)
Subject: Re: [PATCH mlx5-next 1/4] PCI: Configure number of MSI-X vectors for
 SR-IOV VFs
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
References: <20210108005721.GA1403391@bjorn-Precision-5520>
From:   Don Dutile <ddutile@redhat.com>
Message-ID: <ba1e7c38-2a21-40ba-787f-458b979b938f@redhat.com>
Date:   Thu, 7 Jan 2021 22:54:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210108005721.GA1403391@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/21 7:57 PM, Bjorn Helgaas wrote:
> [+cc Alex, Don]
>
> This patch does not actually *configure* the number of vectors, so the
> subject is not quite accurate.  IIUC, this patch adds a sysfs file
> that can be used to configure the number of vectors.  The subject
> should mention the sysfs connection.
>
> On Sun, Jan 03, 2021 at 10:24:37AM +0200, Leon Romanovsky wrote:
>> From: Leon Romanovsky <leonro@nvidia.com>
>>
>> This function is applicable for SR-IOV VFs because such devices allocate
>> their MSI-X table before they will run on the targeted hardware and they
>> can't guess the right amount of vectors.
> This sentence doesn't quite have enough context to make sense to me.
> Per PCIe r5.0, sec 9.5.1.2, I think PFs and VFs have independent MSI-X
> Capabilities.  What is the connection between the PF MSI-X and the VF
> MSI-X?
+1... strip this commit log section and write it with correct, technical content.
PFs & VF's have indep MSIX caps.

Q: is this an issue where (some) mlx5's have a large msi-x capability (per VF) that may overwhelm a system's, (pci-(sub)-tree) MSI / intr capability,
and this is a sysfs-based tuning knob to reduce the max number on such 'challenged' systems?
-- ah; reading further below, it's based on some information gleemed from the VM's capability for intr. support.
     -- or maybe IOMMU (intr) support on the host system, and the VF can't exceed it or config failure in VM... whatever... its some VM cap that's being accomodated.
> The MSI-X table sizes should be determined by the Table Size in the
> Message Control register.  Apparently we write a VF's Table Size
> before a driver is bound to the VF?  Where does that happen?
>
> "Before they run on the targeted hardware" -- do you mean before the
> VF is passed through to a guest virtual machine?  You mention "target
> VM" below, which makes more sense to me.  VFs don't "run"; they're not
> software.  I apologize for not being an expert in the use of VFs.
>
> Please mention the sysfs path in the commit log.
>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> ---
>>   Documentation/ABI/testing/sysfs-bus-pci | 16 +++++++
>>   drivers/pci/iov.c                       | 57 +++++++++++++++++++++++++
>>   drivers/pci/msi.c                       | 30 +++++++++++++
>>   drivers/pci/pci-sysfs.c                 |  1 +
>>   drivers/pci/pci.h                       |  1 +
>>   include/linux/pci.h                     |  8 ++++
>>   6 files changed, 113 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
>> index 25c9c39770c6..30720a9e1386 100644
>> --- a/Documentation/ABI/testing/sysfs-bus-pci
>> +++ b/Documentation/ABI/testing/sysfs-bus-pci
>> @@ -375,3 +375,19 @@ Description:
>>   		The value comes from the PCI kernel device state and can be one
>>   		of: "unknown", "error", "D0", D1", "D2", "D3hot", "D3cold".
>>   		The file is read only.
>> +
>> +What:		/sys/bus/pci/devices/.../vf_msix_vec
>> +Date:		December 2020
>> +Contact:	Leon Romanovsky <leonro@nvidia.com>
>> +Description:
>> +		This file is associated with the SR-IOV VFs. It allows overwrite
>> +		the amount of MSI-X vectors for that VF. This is needed to optimize
>> +		performance of newly bounded devices by allocating the number of
>> +		vectors based on the internal knowledge of targeted VM.
> s/allows overwrite/allows configuration of/
> s/for that/for the/
> s/amount of/number of/
> s/bounded/bound/
>
> What "internal knowledge" is this?  AFAICT this would have to be some
> user-space administration knowledge, not anything internal to the
> kernel.
Correct; likely a libvirt VM (section of its) description;

>
>> +		The values accepted are:
>> +		 * > 0 - this will be number reported by the PCI VF's PCIe MSI-X capability.
> s/PCI// (it's obvious we're talking about PCI here)
> s/PCIe// (MSI-X is not PCIe-specific, and there's no need to mention
> it at all)
>
>> +		 * < 0 - not valid
>> +		 * = 0 - will reset to the device default value
>> +
>> +		The file is writable if no driver is bounded.
>  From the code, it looks more like this:
>
>    The file is writable if the PF is bound to a driver that supports
>    the ->sriov_set_msix_vec_count() callback and there is no driver
>    bound to the VF.
>
> Please wrap all of this to fit in 80 columns like the rest of the file.
>
>> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
>> index 4afd4ee4f7f0..0f8c570361fc 100644
>> --- a/drivers/pci/iov.c
>> +++ b/drivers/pci/iov.c
>> @@ -31,6 +31,7 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
>>   	return (dev->devfn + dev->sriov->offset +
>>   		dev->sriov->stride * vf_id) & 0xff;
>>   }
>> +EXPORT_SYMBOL(pci_iov_virtfn_devfn);
>>
>>   /*
>>    * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
>> @@ -426,6 +427,62 @@ const struct attribute_group sriov_dev_attr_group = {
>>   	.is_visible = sriov_attrs_are_visible,
>>   };
>>
>> +#ifdef CONFIG_PCI_MSI
>> +static ssize_t vf_msix_vec_show(struct device *dev,
>> +				struct device_attribute *attr, char *buf)
>> +{
>> +	struct pci_dev *pdev = to_pci_dev(dev);
>> +	int numb = pci_msix_vec_count(pdev);
>> +
>> +	if (numb < 0)
>> +		return numb;
>> +
>> +	return sprintf(buf, "%d\n", numb);
>> +}
>> +
>> +static ssize_t vf_msix_vec_store(struct device *dev,
>> +				 struct device_attribute *attr, const char *buf,
>> +				 size_t count)
>> +{
>> +	struct pci_dev *vf_dev = to_pci_dev(dev);
>> +	int val, ret;
>> +
>> +	ret = kstrtoint(buf, 0, &val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = pci_set_msix_vec_count(vf_dev, val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return count;
>> +}
>> +static DEVICE_ATTR_RW(vf_msix_vec);
>> +#endif
>> +
>> +static struct attribute *sriov_vf_dev_attrs[] = {
>> +#ifdef CONFIG_PCI_MSI
>> +	&dev_attr_vf_msix_vec.attr,
>> +#endif
>> +	NULL,
>> +};
>> +
>> +static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
>> +					  struct attribute *a, int n)
>> +{
>> +	struct device *dev = kobj_to_dev(kobj);
>> +
>> +	if (dev_is_pf(dev))
>> +		return 0;
>> +
>> +	return a->mode;
>> +}
>> +
>> +const struct attribute_group sriov_vf_dev_attr_group = {
>> +	.attrs = sriov_vf_dev_attrs,
>> +	.is_visible = sriov_vf_attrs_are_visible,
>> +};
>> +
>>   int __weak pcibios_sriov_enable(struct pci_dev *pdev, u16 num_vfs)
>>   {
>>   	return 0;
>> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>> index 3162f88fe940..0bcd705487d9 100644
>> --- a/drivers/pci/msi.c
>> +++ b/drivers/pci/msi.c
>> @@ -991,6 +991,36 @@ int pci_msix_vec_count(struct pci_dev *dev)
>>   }
>>   EXPORT_SYMBOL(pci_msix_vec_count);
>>
>> +/**
>> + * pci_set_msix_vec_count - change the reported number of MSI-X vectors.
> Drop period at end, as other kernel doc in this file does.
>
>> + * This function is applicable for SR-IOV VFs because such devices allocate
>> + * their MSI-X table before they will run on the targeted hardware and they
>> + * can't guess the right amount of vectors.
>> + * @dev: VF device that is going to be changed.
>> + * @numb: amount of MSI-X vectors.
> Rewrite the "such devices allocate..." part based on the questions in
> the commit log.  Same with "targeted hardware."
>
> s/amount of/number of/
> Drop periods at end of parameter descriptions.
>
>> + **/
>> +int pci_set_msix_vec_count(struct pci_dev *dev, int numb)
>> +{
>> +	struct pci_dev *pdev = pci_physfn(dev);
>> +
>> +	if (!dev->msix_cap || !pdev->msix_cap)
>> +		return -EINVAL;
>> +
>> +	if (dev->driver || !pdev->driver ||
>> +	    !pdev->driver->sriov_set_msix_vec_count)
>> +		return -EOPNOTSUPP;
>> +
>> +	if (numb < 0)
>> +		/*
>> +		 * We don't support negative numbers for now,
>> +		 * but maybe in the future it will make sense.
>> +		 */
>> +		return -EINVAL;
>> +
>> +	return pdev->driver->sriov_set_msix_vec_count(dev, numb);
> So we write to a VF sysfs file, get here and look up the PF, call a PF
> driver callback with the VF as an argument, the callback (at least for
> mlx5) looks up the PF from the VF, then does some mlx5-specific magic
> to the PF that influences the VF somehow?
There's no PF lookup above.... it's just checking if a pdev has a driver with the desired msix-cap setting(reduction) feature.

> Help me connect the dots here.  Is this required because of something
> peculiar to mlx5, or is something like this required for all SR-IOV
> devices because of the way the PCIe spec is written?
So, overall, I'm guessing the mlx5 device can have 1000's of MSIX -- say, one per send/receive/completion queue.
This device capability may exceed the max number MSIX a VM can have/support (depending on guestos).
So, a sysfs tunable is used to set the max MSIX available, and thus, the device puts >1 send/rcv/completion queue intr on a given MSIX.

ok, time for Leon to better state what this patch does,
and why it's needed on mlx5 (and may be applicable to other/future high-MSIX devices assigned to VMs (NVME?)).
Hmmm, now that I said it, why is it SRIOV-centric and not pci-device centric (can pass a PF w/high number of MSIX to a VM).

-Don
>> +}
>> +EXPORT_SYMBOL(pci_set_msix_vec_count);
>> +
>>   static int __pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries,
>>   			     int nvec, struct irq_affinity *affd, int flags)
>>   {
>> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
>> index fb072f4b3176..0af2222643c2 100644
>> --- a/drivers/pci/pci-sysfs.c
>> +++ b/drivers/pci/pci-sysfs.c
>> @@ -1557,6 +1557,7 @@ static const struct attribute_group *pci_dev_attr_groups[] = {
>>   	&pci_dev_hp_attr_group,
>>   #ifdef CONFIG_PCI_IOV
>>   	&sriov_dev_attr_group,
>> +	&sriov_vf_dev_attr_group,
>>   #endif
>>   	&pci_bridge_attr_group,
>>   	&pcie_dev_attr_group,
>> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
>> index 5c59365092fa..46396a5da2d9 100644
>> --- a/drivers/pci/pci.h
>> +++ b/drivers/pci/pci.h
>> @@ -502,6 +502,7 @@ resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev, int resno);
>>   void pci_restore_iov_state(struct pci_dev *dev);
>>   int pci_iov_bus_range(struct pci_bus *bus);
>>   extern const struct attribute_group sriov_dev_attr_group;
>> +extern const struct attribute_group sriov_vf_dev_attr_group;
>>   #else
>>   static inline int pci_iov_init(struct pci_dev *dev)
>>   {
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index b32126d26997..1acba40a1b1b 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -856,6 +856,8 @@ struct module;
>>    *		e.g. drivers/net/e100.c.
>>    * @sriov_configure: Optional driver callback to allow configuration of
>>    *		number of VFs to enable via sysfs "sriov_numvfs" file.
>> + * @sriov_set_msix_vec_count: Driver callback to change number of MSI-X vectors
>> + *              exposed by the sysfs "vf_msix_vec" entry.
>>    * @err_handler: See Documentation/PCI/pci-error-recovery.rst
>>    * @groups:	Sysfs attribute groups.
>>    * @driver:	Driver model structure.
>> @@ -871,6 +873,7 @@ struct pci_driver {
>>   	int  (*resume)(struct pci_dev *dev);	/* Device woken up */
>>   	void (*shutdown)(struct pci_dev *dev);
>>   	int  (*sriov_configure)(struct pci_dev *dev, int num_vfs); /* On PF */
>> +	int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int msix_vec_count); /* On PF */
>>   	const struct pci_error_handlers *err_handler;
>>   	const struct attribute_group **groups;
>>   	struct device_driver	driver;
>> @@ -1464,6 +1467,7 @@ struct msix_entry {
>>   int pci_msi_vec_count(struct pci_dev *dev);
>>   void pci_disable_msi(struct pci_dev *dev);
>>   int pci_msix_vec_count(struct pci_dev *dev);
>> +int pci_set_msix_vec_count(struct pci_dev *dev, int numb);
> This patch adds the pci_set_msix_vec_count() definition in pci/msi.c
> and a call in pci/iov.c.  It doesn't need to be declared in
> include/linux/pci.h or exported.  It can be declared in
> drivers/pci/pci.h.
>
>>   void pci_disable_msix(struct pci_dev *dev);
>>   void pci_restore_msi_state(struct pci_dev *dev);
>>   int pci_msi_enabled(void);
>> @@ -2402,6 +2406,10 @@ static inline bool pci_is_thunderbolt_attached(struct pci_dev *pdev)
>>   void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
>>   #endif
>>
>> +#ifdef CONFIG_PCI_IOV
>> +int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id);
>> +#endif
> pci_iov_virtfn_devfn() is already declared in this file.
>
>>   /* Provide the legacy pci_dma_* API */
>>   #include <linux/pci-dma-compat.h>
>>
>> --
>> 2.29.2
>>

