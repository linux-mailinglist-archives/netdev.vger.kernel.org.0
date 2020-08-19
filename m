Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4EE3249CBD
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 13:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgHSLxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 07:53:45 -0400
Received: from foss.arm.com ([217.140.110.172]:33936 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728258AbgHSLv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 07:51:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 226371FB;
        Wed, 19 Aug 2020 04:51:56 -0700 (PDT)
Received: from [10.57.40.122] (unknown [10.57.40.122])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9C7B3F71F;
        Wed, 19 Aug 2020 04:51:44 -0700 (PDT)
Subject: Re: [PATCH 05/28] media/v4l2: remove V4L2-FLAG-MEMORY-NON-CONSISTENT
To:     Tomasz Figa <tfiga@chromium.org>, Christoph Hellwig <hch@lst.de>
Cc:     alsa-devel@alsa-project.org, linux-ia64@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        nouveau@lists.freedesktop.org, linux-nvme@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        linux-scsi@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pawel Osciak <pawel@osciak.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "list@263.net:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-mips@vger.kernel.org,
        "list@263.net:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org
References: <20200819065555.1802761-1-hch@lst.de>
 <20200819065555.1802761-6-hch@lst.de>
 <CAAFQd5COLxjydDYrfx47ht8tj-aNPiaVnC+WyQA7nvpW4gs=ww@mail.gmail.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <62e4f4fc-c8a5-3ee8-c576-fe7178cb4356@arm.com>
Date:   Wed, 19 Aug 2020 12:51:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAAFQd5COLxjydDYrfx47ht8tj-aNPiaVnC+WyQA7nvpW4gs=ww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tomasz,

On 2020-08-19 12:16, Tomasz Figa wrote:
> Hi Christoph,
> 
> On Wed, Aug 19, 2020 at 8:56 AM Christoph Hellwig <hch@lst.de> wrote:
>>
>> The V4L2-FLAG-MEMORY-NON-CONSISTENT flag is entirely unused,
> 
> Could you explain what makes you think it's unused? It's a feature of
> the UAPI generally supported by the videobuf2 framework and relied on
> by Chromium OS to get any kind of reasonable performance when
> accessing V4L2 buffers in the userspace.
> 
>> and causes
>> weird gymanstics with the DMA_ATTR_NON_CONSISTENT flag, which is
>> unimplemented except on PARISC and some MIPS configs, and about to be
>> removed.
> 
> It is implemented by the generic DMA mapping layer [1], which is used
> by a number of architectures including ARM64 and supposed to be used
> by new architectures going forward.

AFAICS all that V4L2_FLAG_MEMORY_NON_CONSISTENT does is end up 
controling whether DMA_ATTR_NON_CONSISTENT is added to vb2_queue::dma_attrs.

Please can you point to where DMA_ATTR_NON_CONSISTENT does anything at 
all on arm64?

Also, I posit that videobuf2 is not actually relying on 
DMA_ATTR_NON_CONSISTENT anyway, since it's clearly not using it properly:

"By using this API, you are guaranteeing to the platform
that you have all the correct and necessary sync points for this memory
in the driver should it choose to return non-consistent memory."

$ git grep dma_cache_sync drivers/media
$

Robin.

> [1] https://elixir.bootlin.com/linux/v5.9-rc1/source/kernel/dma/mapping.c#L341
> 
> When removing features from generic kernel code, I'd suggest first
> providing viable alternatives for its users, rather than killing the
> users altogether.
> 
> Given the above, I'm afraid I have to NAK this.
> 
> Best regards,
> Tomasz
> 
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   .../userspace-api/media/v4l/buffer.rst        | 17 ---------
>>   .../media/v4l/vidioc-reqbufs.rst              |  1 -
>>   .../media/common/videobuf2/videobuf2-core.c   | 36 +------------------
>>   .../common/videobuf2/videobuf2-dma-contig.c   | 19 ----------
>>   .../media/common/videobuf2/videobuf2-dma-sg.c |  3 +-
>>   .../media/common/videobuf2/videobuf2-v4l2.c   | 12 -------
>>   include/media/videobuf2-core.h                |  3 +-
>>   include/uapi/linux/videodev2.h                |  2 --
>>   8 files changed, 3 insertions(+), 90 deletions(-)
>>
>> diff --git a/Documentation/userspace-api/media/v4l/buffer.rst b/Documentation/userspace-api/media/v4l/buffer.rst
>> index 57e752aaf414a7..2044ed13cd9d7d 100644
>> --- a/Documentation/userspace-api/media/v4l/buffer.rst
>> +++ b/Documentation/userspace-api/media/v4l/buffer.rst
>> @@ -701,23 +701,6 @@ Memory Consistency Flags
>>       :stub-columns: 0
>>       :widths:       3 1 4
>>
>> -    * .. _`V4L2-FLAG-MEMORY-NON-CONSISTENT`:
>> -
>> -      - ``V4L2_FLAG_MEMORY_NON_CONSISTENT``
>> -      - 0x00000001
>> -      - A buffer is allocated either in consistent (it will be automatically
>> -       coherent between the CPU and the bus) or non-consistent memory. The
>> -       latter can provide performance gains, for instance the CPU cache
>> -       sync/flush operations can be avoided if the buffer is accessed by the
>> -       corresponding device only and the CPU does not read/write to/from that
>> -       buffer. However, this requires extra care from the driver -- it must
>> -       guarantee memory consistency by issuing a cache flush/sync when
>> -       consistency is needed. If this flag is set V4L2 will attempt to
>> -       allocate the buffer in non-consistent memory. The flag takes effect
>> -       only if the buffer is used for :ref:`memory mapping <mmap>` I/O and the
>> -       queue reports the :ref:`V4L2_BUF_CAP_SUPPORTS_MMAP_CACHE_HINTS
>> -       <V4L2-BUF-CAP-SUPPORTS-MMAP-CACHE-HINTS>` capability.
>> -
>>   .. c:type:: v4l2_memory
>>
>>   enum v4l2_memory
>> diff --git a/Documentation/userspace-api/media/v4l/vidioc-reqbufs.rst b/Documentation/userspace-api/media/v4l/vidioc-reqbufs.rst
>> index 75d894d9c36c42..3180c111d368ee 100644
>> --- a/Documentation/userspace-api/media/v4l/vidioc-reqbufs.rst
>> +++ b/Documentation/userspace-api/media/v4l/vidioc-reqbufs.rst
>> @@ -169,7 +169,6 @@ aborting or finishing any DMA in progress, an implicit
>>         - This capability is set by the driver to indicate that the queue supports
>>           cache and memory management hints. However, it's only valid when the
>>           queue is used for :ref:`memory mapping <mmap>` streaming I/O. See
>> -        :ref:`V4L2_FLAG_MEMORY_NON_CONSISTENT <V4L2-FLAG-MEMORY-NON-CONSISTENT>`,
>>           :ref:`V4L2_BUF_FLAG_NO_CACHE_INVALIDATE <V4L2-BUF-FLAG-NO-CACHE-INVALIDATE>` and
>>           :ref:`V4L2_BUF_FLAG_NO_CACHE_CLEAN <V4L2-BUF-FLAG-NO-CACHE-CLEAN>`.
>>
>> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
>> index f544d3393e9d6b..66a41cef33c1b1 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-core.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
>> @@ -721,39 +721,14 @@ int vb2_verify_memory_type(struct vb2_queue *q,
>>   }
>>   EXPORT_SYMBOL(vb2_verify_memory_type);
>>
>> -static void set_queue_consistency(struct vb2_queue *q, bool consistent_mem)
>> -{
>> -       q->dma_attrs &= ~DMA_ATTR_NON_CONSISTENT;
>> -
>> -       if (!vb2_queue_allows_cache_hints(q))
>> -               return;
>> -       if (!consistent_mem)
>> -               q->dma_attrs |= DMA_ATTR_NON_CONSISTENT;
>> -}
>> -
>> -static bool verify_consistency_attr(struct vb2_queue *q, bool consistent_mem)
>> -{
>> -       bool queue_is_consistent = !(q->dma_attrs & DMA_ATTR_NON_CONSISTENT);
>> -
>> -       if (consistent_mem != queue_is_consistent) {
>> -               dprintk(q, 1, "memory consistency model mismatch\n");
>> -               return false;
>> -       }
>> -       return true;
>> -}
>> -
>>   int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>>                       unsigned int flags, unsigned int *count)
>>   {
>>          unsigned int num_buffers, allocated_buffers, num_planes = 0;
>>          unsigned plane_sizes[VB2_MAX_PLANES] = { };
>> -       bool consistent_mem = true;
>>          unsigned int i;
>>          int ret;
>>
>> -       if (flags & V4L2_FLAG_MEMORY_NON_CONSISTENT)
>> -               consistent_mem = false;
>> -
>>          if (q->streaming) {
>>                  dprintk(q, 1, "streaming active\n");
>>                  return -EBUSY;
>> @@ -765,8 +740,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>>          }
>>
>>          if (*count == 0 || q->num_buffers != 0 ||
>> -           (q->memory != VB2_MEMORY_UNKNOWN && q->memory != memory) ||
>> -           !verify_consistency_attr(q, consistent_mem)) {
>> +           (q->memory != VB2_MEMORY_UNKNOWN && q->memory != memory)) {
>>                  /*
>>                   * We already have buffers allocated, so first check if they
>>                   * are not in use and can be freed.
>> @@ -803,7 +777,6 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>>          num_buffers = min_t(unsigned int, num_buffers, VB2_MAX_FRAME);
>>          memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
>>          q->memory = memory;
>> -       set_queue_consistency(q, consistent_mem);
>>
>>          /*
>>           * Ask the driver how many buffers and planes per buffer it requires.
>> @@ -894,12 +867,8 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
>>   {
>>          unsigned int num_planes = 0, num_buffers, allocated_buffers;
>>          unsigned plane_sizes[VB2_MAX_PLANES] = { };
>> -       bool consistent_mem = true;
>>          int ret;
>>
>> -       if (flags & V4L2_FLAG_MEMORY_NON_CONSISTENT)
>> -               consistent_mem = false;
>> -
>>          if (q->num_buffers == VB2_MAX_FRAME) {
>>                  dprintk(q, 1, "maximum number of buffers already allocated\n");
>>                  return -ENOBUFS;
>> @@ -912,15 +881,12 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
>>                  }
>>                  memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
>>                  q->memory = memory;
>> -               set_queue_consistency(q, consistent_mem);
>>                  q->waiting_for_buffers = !q->is_output;
>>          } else {
>>                  if (q->memory != memory) {
>>                          dprintk(q, 1, "memory model mismatch\n");
>>                          return -EINVAL;
>>                  }
>> -               if (!verify_consistency_attr(q, consistent_mem))
>> -                       return -EINVAL;
>>          }
>>
>>          num_buffers = min(*count, VB2_MAX_FRAME - q->num_buffers);
>> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
>> index ec3446cc45b8da..7b1b86ec942d7d 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
>> @@ -42,11 +42,6 @@ struct vb2_dc_buf {
>>          struct dma_buf_attachment       *db_attach;
>>   };
>>
>> -static inline bool vb2_dc_buffer_consistent(unsigned long attr)
>> -{
>> -       return !(attr & DMA_ATTR_NON_CONSISTENT);
>> -}
>> -
>>   /*********************************************/
>>   /*        scatterlist table functions        */
>>   /*********************************************/
>> @@ -341,13 +336,6 @@ static int
>>   vb2_dc_dmabuf_ops_begin_cpu_access(struct dma_buf *dbuf,
>>                                     enum dma_data_direction direction)
>>   {
>> -       struct vb2_dc_buf *buf = dbuf->priv;
>> -       struct sg_table *sgt = buf->dma_sgt;
>> -
>> -       if (vb2_dc_buffer_consistent(buf->attrs))
>> -               return 0;
>> -
>> -       dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>>          return 0;
>>   }
>>
>> @@ -355,13 +343,6 @@ static int
>>   vb2_dc_dmabuf_ops_end_cpu_access(struct dma_buf *dbuf,
>>                                   enum dma_data_direction direction)
>>   {
>> -       struct vb2_dc_buf *buf = dbuf->priv;
>> -       struct sg_table *sgt = buf->dma_sgt;
>> -
>> -       if (vb2_dc_buffer_consistent(buf->attrs))
>> -               return 0;
>> -
>> -       dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>>          return 0;
>>   }
>>
>> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
>> index 0a40e00f0d7e5c..a86fce5d8ea8bf 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
>> @@ -123,8 +123,7 @@ static void *vb2_dma_sg_alloc(struct device *dev, unsigned long dma_attrs,
>>          /*
>>           * NOTE: dma-sg allocates memory using the page allocator directly, so
>>           * there is no memory consistency guarantee, hence dma-sg ignores DMA
>> -        * attributes passed from the upper layer. That means that
>> -        * V4L2_FLAG_MEMORY_NON_CONSISTENT has no effect on dma-sg buffers.
>> +        * attributes passed from the upper layer.
>>           */
>>          buf->pages = kvmalloc_array(buf->num_pages, sizeof(struct page *),
>>                                      GFP_KERNEL | __GFP_ZERO);
>> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> index 30caad27281e1a..de83ad48783821 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> @@ -722,20 +722,11 @@ static void fill_buf_caps(struct vb2_queue *q, u32 *caps)
>>   #endif
>>   }
>>
>> -static void clear_consistency_attr(struct vb2_queue *q,
>> -                                  int memory,
>> -                                  unsigned int *flags)
>> -{
>> -       if (!q->allow_cache_hints || memory != V4L2_MEMORY_MMAP)
>> -               *flags &= ~V4L2_FLAG_MEMORY_NON_CONSISTENT;
>> -}
>> -
>>   int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>>   {
>>          int ret = vb2_verify_memory_type(q, req->memory, req->type);
>>
>>          fill_buf_caps(q, &req->capabilities);
>> -       clear_consistency_attr(q, req->memory, &req->flags);
>>          return ret ? ret : vb2_core_reqbufs(q, req->memory,
>>                                              req->flags, &req->count);
>>   }
>> @@ -769,7 +760,6 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
>>          unsigned i;
>>
>>          fill_buf_caps(q, &create->capabilities);
>> -       clear_consistency_attr(q, create->memory, &create->flags);
>>          create->index = q->num_buffers;
>>          if (create->count == 0)
>>                  return ret != -EBUSY ? ret : 0;
>> @@ -998,7 +988,6 @@ int vb2_ioctl_reqbufs(struct file *file, void *priv,
>>          int res = vb2_verify_memory_type(vdev->queue, p->memory, p->type);
>>
>>          fill_buf_caps(vdev->queue, &p->capabilities);
>> -       clear_consistency_attr(vdev->queue, p->memory, &p->flags);
>>          if (res)
>>                  return res;
>>          if (vb2_queue_is_busy(vdev, file))
>> @@ -1021,7 +1010,6 @@ int vb2_ioctl_create_bufs(struct file *file, void *priv,
>>
>>          p->index = vdev->queue->num_buffers;
>>          fill_buf_caps(vdev->queue, &p->capabilities);
>> -       clear_consistency_attr(vdev->queue, p->memory, &p->flags);
>>          /*
>>           * If count == 0, then just check if memory and type are valid.
>>           * Any -EBUSY result from vb2_verify_memory_type can be mapped to 0.
>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>> index 52ef92049073e3..4c7f25b07e9375 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -744,8 +744,7 @@ void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
>>    * vb2_core_reqbufs() - Initiate streaming.
>>    * @q:         pointer to &struct vb2_queue with videobuf2 queue.
>>    * @memory:    memory type, as defined by &enum vb2_memory.
>> - * @flags:     auxiliary queue/buffer management flags. Currently, the only
>> - *             used flag is %V4L2_FLAG_MEMORY_NON_CONSISTENT.
>> + * @flags:     auxiliary queue/buffer management flags.
>>    * @count:     requested buffer count.
>>    *
>>    * Videobuf2 core helper to implement VIDIOC_REQBUF() operation. It is called
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index c7b70ff53bc1dd..5c00f63d9c1b58 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -191,8 +191,6 @@ enum v4l2_memory {
>>          V4L2_MEMORY_DMABUF           = 4,
>>   };
>>
>> -#define V4L2_FLAG_MEMORY_NON_CONSISTENT                (1 << 0)
>> -
>>   /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
>>   enum v4l2_colorspace {
>>          /*
>> --
>> 2.28.0
>>
>> _______________________________________________
>> iommu mailing list
>> iommu@lists.linux-foundation.org
>> https://lists.linuxfoundation.org/mailman/listinfo/iommu
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
