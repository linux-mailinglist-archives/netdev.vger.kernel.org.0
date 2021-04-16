Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F6C3617A0
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 04:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235482AbhDPCnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 22:43:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:24272 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhDPCnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 22:43:01 -0400
IronPort-SDR: sNVxYt0gpwfW+WiP5WHI8YFP+fH9tuNLFJvgsF33VWoyTPX00NANI0IOxmJ4vOfq8iAoU7ff1u
 q99e14qSRrAQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="195092046"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="195092046"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 19:42:37 -0700
IronPort-SDR: oCpKOHXPVkd9xhaUJhOgUWuyrYg5UdcM4noz9G0FOIgZeej2MtyPEhRYDxhwGZNXi9v1E/cdiC
 sX/2BvZj+g6A==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="418971473"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.208.190]) ([10.254.208.190])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 19:42:32 -0700
Subject: Re: [PATCH V2 3/3] vDPA/ifcvf: get_config_size should return dev
 specific config size
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     lulu@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20210415095336.4792-1-lingshan.zhu@intel.com>
 <20210415095336.4792-4-lingshan.zhu@intel.com>
 <20210415134838.3hn33estolycag4p@steredhat>
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <e1abd531-d8f9-d9ba-3dfe-2eafcd75c58f@linux.intel.com>
Date:   Fri, 16 Apr 2021 10:42:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415134838.3hn33estolycag4p@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2021 9:48 PM, Stefano Garzarella wrote:
> On Thu, Apr 15, 2021 at 05:53:36PM +0800, Zhu Lingshan wrote:
>> get_config_size() should return the size based on the decected
>> device type.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>> drivers/vdpa/ifcvf/ifcvf_main.c | 18 +++++++++++++++++-
>> 1 file changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index cea1313b1a3f..6844c49fe1de 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -347,7 +347,23 @@ static u32 ifcvf_vdpa_get_vq_align(struct 
>> vdpa_device *vdpa_dev)
>>
>> static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
>> {
>> -    return sizeof(struct virtio_net_config);
>> +    struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>> +    struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>> +    struct pci_dev *pdev = adapter->pdev;
>> +    size_t size;
>> +
>> +    if (vf->dev_type == VIRTIO_ID_NET)
>> +        size = sizeof(struct virtio_net_config);
>> +
>> +    else if (vf->dev_type == VIRTIO_ID_BLOCK)
>> +        size = sizeof(struct virtio_blk_config);
>> +
>> +    else {
>> +        size = 0;
>> +        IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
>> +    }
>
> I slightly prefer the switch, but I don't have a strong opinion.
>
> However, if we want to use if/else, we should follow 
> `Documentation/process/coding-style.rst` line 166:
>    Note that the closing brace is empty on a line of its own, 
> **except** in
>    the cases where it is followed by a continuation of the same 
> statement,
>    ie a ``while`` in a do-statement or an ``else`` in an if-statement, 
> like
>
> also `scripts/checkpatch.pl --strict` complains:
>
>    CHECK: braces {} should be used on all arms of this statement
>    #209: FILE: drivers/vdpa/ifcvf/ifcvf_main.c:355:
>    +    if (vf->dev_type == VIRTIO_ID_NET)
>    [...]
>    +    else if (vf->dev_type == VIRTIO_ID_BLOCK)
>    [...]
>    +    else {
>    [...]
>
>    CHECK: Unbalanced braces around else statement
>    #215: FILE: drivers/vdpa/ifcvf/ifcvf_main.c:361:
>    +    else {
Thanks Stefano, the reason is we only have one line code after if, so 
looks like {} is unnecessary, I agree switch can clear up
code style confusions. I will add this in v3.

Thanks!
>
> Thanks,
> Stefano
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

