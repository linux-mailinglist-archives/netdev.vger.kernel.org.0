Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F88422C87C
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 16:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgGXOwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 10:52:45 -0400
Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net ([209.97.182.222]:54570
        "HELO zg8tmja5ljk3lje4mi4ymjia.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1726170AbgGXOwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 10:52:45 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jul 2020 10:52:43 EDT
Received: from [166.111.139.116] (unknown [166.111.139.116])
        by app-5 (Coremail) with SMTP id EwQGZQAn2UkG9BpfubdyAw--.49696S2;
        Fri, 24 Jul 2020 22:45:26 +0800 (CST)
From:   Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Subject: Rule about streaming DMA mapping
To:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        kuba@kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <73f8f864-058a-c899-b07d-5dc1e4f3e9e6@tsinghua.edu.cn>
Date:   Fri, 24 Jul 2020 22:45:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: EwQGZQAn2UkG9BpfubdyAw--.49696S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWF4UuFW5tFyDZr1fKrW3Jrb_yoW5WrWkpF
        4kXF15trWYqr1ktryUGr1rXryUJw1kt34UGr1UJ3Z5u3y5Jr1jqry0qr10gr1UCw4kZr4U
        Jr1UXw4kZr1UtwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUv2b7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY
        02Avz4vE14v_Xryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
        6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE
        14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa
        7IU5gL07UUUUU==
X-CM-SenderInfo: xedlyxhdmxq3pvlqwxlxdovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

 From the book "Linux device drivers" (3rd edition), I find an 
interesting rule for streaming DMA mapping:

Once a buffer has been mapped, it belongs to the device, not the 
processor. Until
the buffer has been unmapped, the driver should not touch its contents 
in any
way. Only after dma_unmap_single has been called is it safe for the 
driver to
access the contents of the buffer (with one exception that we see shortly).
Among other things, this rule implies that a buffer being written to a 
device cannot
be mapped until it contains all the data to write.

I find some violations about this rule, and there are two examples in 
Linux-5.6:

=== EXAMPLE 1 ===
In vmxnet3_probe_device() in drivers/net/vmxnet3/vmxnet3_drv.c:
     adapter->adapter_pa = dma_map_single(&adapter->pdev->dev, adapter,
                          sizeof(struct vmxnet3_adapter),
                          PCI_DMA_TODEVICE);
     if (dma_mapping_error(&adapter->pdev->dev, adapter->adapter_pa)) {
         dev_err(&pdev->dev, "Failed to map dma\n");
         err = -EFAULT;
         goto err_set_mask;
     }
     adapter->shared = dma_alloc_coherent(
                 &adapter->pdev->dev,
                 sizeof(struct Vmxnet3_DriverShared),
                 &adapter->shared_pa, GFP_KERNEL);
     if (!adapter->shared) {
         dev_err(&pdev->dev, "Failed to allocate memory\n");
         err = -ENOMEM;
         goto err_alloc_shared;
     }

     adapter->num_rx_queues = num_rx_queues;
     adapter->num_tx_queues = num_tx_queues;
     adapter->rx_buf_per_pkt = 1;

The variable "adapter" is mapped to streaming DMA, but its fields are 
used before this variable is unmapped.

=== EXAMPLE 2 ===
In queue_skb() in drivers/atm/idt77252.c:
     IDT77252_PRV_PADDR(skb) = dma_map_single(&card->pcidev->dev, skb->data,
                          skb->len, DMA_TO_DEVICE);

     error = -EINVAL;

     if (oam) {
         if (skb->len != 52)
             goto errout;

         tbd->word_1 = SAR_TBD_OAM | ATM_CELL_PAYLOAD | SAR_TBD_EPDU;
         tbd->word_2 = IDT77252_PRV_PADDR(skb) + 4;
         tbd->word_3 = 0x00000000;
         tbd->word_4 = (skb->data[0] << 24) | (skb->data[1] << 16) |
                   (skb->data[2] <<  8) | (skb->data[3] <<  0);

The array "skb->data" is mapped to streaming DMA, but its elements are 
used before this array is unmapped.

Because I am not familiar with streaming DMA mapping, I wonder whether 
these violations are real?
If they are real, what problems can they cause?

Thanks a lot :)


Best wishes,
Jia-Ju Bai

