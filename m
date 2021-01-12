Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735592F26AC
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 04:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbhALD1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 22:27:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27595 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726893AbhALD1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 22:27:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610421952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VWr2T052hL7ZZCsKGI4QVVcBlDC0MV1Qygnm5Lbm6KM=;
        b=MQskBarsZxw/0up/8jyLrbkPbV7U/8esldN1OtGy15WYWpEJgVWgV324P+8y5o/3E2Yv7J
        zaxg17I6YQOCX8bgwv166Si0yfBrcUFCAHxK1FX+aQfTwU767R+gYVRLgcPGM4TDSKHgvE
        +GiOkdb7Ii2NGIBO2a+5NaZ5LwvtE8U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-Xtqb7fN6MuKZ4t61dfMkKg-1; Mon, 11 Jan 2021 22:25:48 -0500
X-MC-Unique: Xtqb7fN6MuKZ4t61dfMkKg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 994D8804002;
        Tue, 12 Jan 2021 03:25:46 +0000 (UTC)
Received: from [10.3.112.139] (ovpn-112-139.phx2.redhat.com [10.3.112.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96EC85B4A7;
        Tue, 12 Jan 2021 03:25:42 +0000 (UTC)
Subject: Re: [PATCH mlx5-next v1 1/5] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20210110150727.1965295-1-leon@kernel.org>
 <20210110150727.1965295-2-leon@kernel.org>
 <CAKgT0UcJrSNMPAOoniRSnUn+wyRUkL62AfgR3-8QbAkak=pQ=w@mail.gmail.com>
From:   Don Dutile <ddutile@redhat.com>
Message-ID: <397a7ed5-c98f-560e-107e-0b354bebb9bd@redhat.com>
Date:   Mon, 11 Jan 2021 22:25:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UcJrSNMPAOoniRSnUn+wyRUkL62AfgR3-8QbAkak=pQ=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/21 2:30 PM, Alexander Duyck wrote:
> On Sun, Jan 10, 2021 at 7:12 AM Leon Romanovsky <leon@kernel.org> wrote:
>> From: Leon Romanovsky <leonro@nvidia.com>
>>
>> Extend PCI sysfs interface with a new callback that allows configure
>> the number of MSI-X vectors for specific SR-IO VF. This is needed
>> to optimize the performance of newly bound devices by allocating
>> the number of vectors based on the administrator knowledge of targeted VM.
>>
>> This function is applicable for SR-IOV VF because such devices allocate
>> their MSI-X table before they will run on the VMs and HW can't guess the
>> right number of vectors, so the HW allocates them statically and equally.
>>
>> The newly added /sys/bus/pci/devices/.../vf_msix_vec file will be seen
>> for the VFs and it is writable as long as a driver is not bounded to the VF.
>>
>> The values accepted are:
>>   * > 0 - this will be number reported by the VF's MSI-X capability
>>   * < 0 - not valid
>>   * = 0 - will reset to the device default value
>>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> ---
>>   Documentation/ABI/testing/sysfs-bus-pci | 20 ++++++++
>>   drivers/pci/iov.c                       | 62 +++++++++++++++++++++++++
>>   drivers/pci/msi.c                       | 29 ++++++++++++
>>   drivers/pci/pci-sysfs.c                 |  1 +
>>   drivers/pci/pci.h                       |  2 +
>>   include/linux/pci.h                     |  8 +++-
>>   6 files changed, 121 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
>> index 25c9c39770c6..05e26e5da54e 100644
>> --- a/Documentation/ABI/testing/sysfs-bus-pci
>> +++ b/Documentation/ABI/testing/sysfs-bus-pci
>> @@ -375,3 +375,23 @@ Description:
>>                  The value comes from the PCI kernel device state and can be one
>>                  of: "unknown", "error", "D0", D1", "D2", "D3hot", "D3cold".
>>                  The file is read only.
>> +
>> +What:          /sys/bus/pci/devices/.../vf_msix_vec
> So the name for this doesn't seem to match existing SR-IOV naming.  It
> seems like this should probably be something like sriov_vf_msix_count
> in order to be closer to the actual naming of what is being dealt
> with.
>
>> +Date:          December 2020
>> +Contact:       Leon Romanovsky <leonro@nvidia.com>
>> +Description:
>> +               This file is associated with the SR-IOV VFs.
>> +               It allows configuration of the number of MSI-X vectors for
>> +               the VF. This is needed to optimize performance of newly bound
>> +               devices by allocating the number of vectors based on the
>> +               administrator knowledge of targeted VM.
>> +
>> +               The values accepted are:
>> +                * > 0 - this will be number reported by the VF's MSI-X
>> +                        capability
>> +                * < 0 - not valid
>> +                * = 0 - will reset to the device default value
>> +
>> +               The file is writable if the PF is bound to a driver that
>> +               supports the ->sriov_set_msix_vec_count() callback and there
>> +               is no driver bound to the VF.
>> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
>> index 4afd4ee4f7f0..42c0df4158d1 100644
>> --- a/drivers/pci/iov.c
>> +++ b/drivers/pci/iov.c
>> @@ -31,6 +31,7 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
>>          return (dev->devfn + dev->sriov->offset +
>>                  dev->sriov->stride * vf_id) & 0xff;
>>   }
>> +EXPORT_SYMBOL(pci_iov_virtfn_devfn);
>>
>>   /*
>>    * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
>> @@ -426,6 +427,67 @@ const struct attribute_group sriov_dev_attr_group = {
>>          .is_visible = sriov_attrs_are_visible,
>>   };
>>
>> +#ifdef CONFIG_PCI_MSI
>> +static ssize_t vf_msix_vec_show(struct device *dev,
>> +                               struct device_attribute *attr, char *buf)
>> +{
>> +       struct pci_dev *pdev = to_pci_dev(dev);
>> +       int numb = pci_msix_vec_count(pdev);
>> +       struct pci_dev *pfdev;
>> +
>> +       if (numb < 0)
>> +               return numb;
>> +
>> +       pfdev = pci_physfn(pdev);
>> +       if (!pfdev->driver || !pfdev->driver->sriov_set_msix_vec_count)
>> +               return -EOPNOTSUPP;
>> +
> This doesn't make sense to me. You are getting the vector count for
> the PCI device and reporting that. Are you expecting to call this on
> the PF or the VFs? It seems like this should be a PF attribute and not
> be called on the individual VFs.
>
> If you are calling this on the VFs then it doesn't really make any
> sense anyway since the VF is not a "VF PCI dev representor" and
> shouldn't be treated as such. In my opinion if we are going to be
> doing per-port resource limiting that is something that might make
> more sense as a part of the devlink configuration for the VF since the
> actual change won't be visible to an assigned device.
if the op were just limited to nic ports, devlink may be used; but I believe Leon is trying to handle it from an sriov/vf perspective for other non-nic devices as well,
e.g., ib ports, nvme vf's (which don't have a port concept at all).

>> +       return sprintf(buf, "%d\n", numb);
>> +}
>> +
>> +static ssize_t vf_msix_vec_store(struct device *dev,
>> +                                struct device_attribute *attr, const char *buf,
>> +                                size_t count)
>> +{
>> +       struct pci_dev *vf_dev = to_pci_dev(dev);
>> +       int val, ret;
>> +
>> +       ret = kstrtoint(buf, 0, &val);
>> +       if (ret)
>> +               return ret;
>> +
>> +       ret = pci_set_msix_vec_count(vf_dev, val);
>> +       if (ret)
>> +               return ret;
>> +
>> +       return count;
>> +}
>> +static DEVICE_ATTR_RW(vf_msix_vec);
>> +#endif
>> +
>> +static struct attribute *sriov_vf_dev_attrs[] = {
>> +#ifdef CONFIG_PCI_MSI
>> +       &dev_attr_vf_msix_vec.attr,
>> +#endif
>> +       NULL,
>> +};
>> +
>> +static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
>> +                                         struct attribute *a, int n)
>> +{
>> +       struct device *dev = kobj_to_dev(kobj);
>> +
>> +       if (dev_is_pf(dev))
>> +               return 0;
>> +
>> +       return a->mode;
>> +}
>> +
>> +const struct attribute_group sriov_vf_dev_attr_group = {
>> +       .attrs = sriov_vf_dev_attrs,
>> +       .is_visible = sriov_vf_attrs_are_visible,
>> +};
>> +
>>   int __weak pcibios_sriov_enable(struct pci_dev *pdev, u16 num_vfs)
>>   {
>>          return 0;
>> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>> index 3162f88fe940..20705ca94666 100644
>> --- a/drivers/pci/msi.c
>> +++ b/drivers/pci/msi.c
>> @@ -991,6 +991,35 @@ int pci_msix_vec_count(struct pci_dev *dev)
>>   }
>>   EXPORT_SYMBOL(pci_msix_vec_count);
>>
>> +/**
>> + * pci_set_msix_vec_count - change the reported number of MSI-X vectors
>> + * This function is applicable for SR-IOV VF because such devices allocate
>> + * their MSI-X table before they will run on the VMs and HW can't guess the
>> + * right number of vectors, so the HW allocates them statically and equally.
>> + * @dev: VF device that is going to be changed
>> + * @numb: amount of MSI-X vectors
>> + **/
>> +int pci_set_msix_vec_count(struct pci_dev *dev, int numb)
>> +{
>> +       struct pci_dev *pdev = pci_physfn(dev);
>> +
>> +       if (!dev->msix_cap || !pdev->msix_cap)
>> +               return -EINVAL;
>> +
>> +       if (dev->driver || !pdev->driver ||
>> +           !pdev->driver->sriov_set_msix_vec_count)
>> +               return -EOPNOTSUPP;
>> +
>> +       if (numb < 0)
>> +               /*
>> +                * We don't support negative numbers for now,
>> +                * but maybe in the future it will make sense.
>> +                */
>> +               return -EINVAL;
>> +
>> +       return pdev->driver->sriov_set_msix_vec_count(dev, numb);
>> +}
>> +
> If you are going to have a set operation for this it would make sense
> to have a get operation. Your show operation seems unbalanced since
> you are expecting to call it on the VF directly which just seems
> wrong.
>
>>   static int __pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries,
>>                               int nvec, struct irq_affinity *affd, int flags)
>>   {
>> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
>> index fb072f4b3176..0af2222643c2 100644
>> --- a/drivers/pci/pci-sysfs.c
>> +++ b/drivers/pci/pci-sysfs.c
>> @@ -1557,6 +1557,7 @@ static const struct attribute_group *pci_dev_attr_groups[] = {
>>          &pci_dev_hp_attr_group,
>>   #ifdef CONFIG_PCI_IOV
>>          &sriov_dev_attr_group,
>> +       &sriov_vf_dev_attr_group,
>>   #endif
>>          &pci_bridge_attr_group,
>>          &pcie_dev_attr_group,
>> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
>> index 5c59365092fa..1fd273077637 100644
>> --- a/drivers/pci/pci.h
>> +++ b/drivers/pci/pci.h
>> @@ -183,6 +183,7 @@ extern unsigned int pci_pm_d3hot_delay;
>>
>>   #ifdef CONFIG_PCI_MSI
>>   void pci_no_msi(void);
>> +int pci_set_msix_vec_count(struct pci_dev *dev, int numb);
>>   #else
>>   static inline void pci_no_msi(void) { }
>>   #endif
>> @@ -502,6 +503,7 @@ resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev, int resno);
>>   void pci_restore_iov_state(struct pci_dev *dev);
>>   int pci_iov_bus_range(struct pci_bus *bus);
>>   extern const struct attribute_group sriov_dev_attr_group;
>> +extern const struct attribute_group sriov_vf_dev_attr_group;
>>   #else
>>   static inline int pci_iov_init(struct pci_dev *dev)
>>   {
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index b32126d26997..a17cfc28eb66 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -856,6 +856,8 @@ struct module;
>>    *             e.g. drivers/net/e100.c.
>>    * @sriov_configure: Optional driver callback to allow configuration of
>>    *             number of VFs to enable via sysfs "sriov_numvfs" file.
>> + * @sriov_set_msix_vec_count: Driver callback to change number of MSI-X vectors
>> + *              exposed by the sysfs "vf_msix_vec" entry.
> Hopefully it is doing more than just changing the displayed sysfs
> value. What is the effect of changing that value on the actual system
> state? I'm assuming this is some limit that is enforced by the PF or
> the device firmware?
>
>
>>    * @err_handler: See Documentation/PCI/pci-error-recovery.rst
>>    * @groups:    Sysfs attribute groups.
>>    * @driver:    Driver model structure.
>> @@ -871,6 +873,7 @@ struct pci_driver {
>>          int  (*resume)(struct pci_dev *dev);    /* Device woken up */
>>          void (*shutdown)(struct pci_dev *dev);
>>          int  (*sriov_configure)(struct pci_dev *dev, int num_vfs); /* On PF */
>> +       int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int msix_vec_count); /* On PF */
>>          const struct pci_error_handlers *err_handler;
>>          const struct attribute_group **groups;
>>          struct device_driver    driver;
>> @@ -2057,7 +2060,6 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
>>
>>   #ifdef CONFIG_PCI_IOV
>>   int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
>> -int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
>>
>>   int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
>>   void pci_disable_sriov(struct pci_dev *dev);
>> @@ -2402,6 +2404,10 @@ static inline bool pci_is_thunderbolt_attached(struct pci_dev *pdev)
>>   void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
>>   #endif
>>
>> +#ifdef CONFIG_PCI_IOV
>> +int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id);
>> +#endif
>> +
>>   /* Provide the legacy pci_dma_* API */
>>   #include <linux/pci-dma-compat.h>
>>
>> --
>> 2.29.2
>>

