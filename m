Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EE53FFF8A
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 14:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348496AbhICMH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 08:07:59 -0400
Received: from mga07.intel.com ([134.134.136.100]:44122 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235253AbhICMH6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 08:07:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="283109531"
X-IronPort-AV: E=Sophos;i="5.85,265,1624345200"; 
   d="gz'50?scan'50,208,50";a="283109531"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 05:06:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,265,1624345200"; 
   d="gz'50?scan'50,208,50";a="500338458"
Received: from lkp-server01.sh.intel.com (HELO 2115029a3e5c) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 03 Sep 2021 05:06:51 -0700
Received: from kbuild by 2115029a3e5c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mM7y7-0000Pp-45; Fri, 03 Sep 2021 12:06:51 +0000
Date:   Fri, 3 Sep 2021 20:05:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 3/6] vhost/vsock: support MSG_EOR bit
 processing
Message-ID: <202109031928.8Uax34Yf-lkp@intel.com>
References: <20210903061541.3187840-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20210903061541.3187840-1-arseny.krasnov@kaspersky.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Arseny,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Arseny-Krasnov/virtio-vsock-introduce-MSG_EOR-flag-for-SEQPACKET/20210903-141720
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 29ce8f9701072fc221d9c38ad952de1a9578f95c
config: i386-randconfig-s001-20210903 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-rc1-dirty
        # https://github.com/0day-ci/linux/commit/18c4eca4204f01fb1f94bf35e760436cb537d9b3
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Arseny-Krasnov/virtio-vsock-introduce-MSG_EOR-flag-for-SEQPACKET/20210903-141720
        git checkout 18c4eca4204f01fb1f94bf35e760436cb537d9b3
        # save the attached .config to linux build tree
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash drivers/vhost/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/vhost/vsock.c:192:37: sparse: sparse: restricted __le32 degrades to integer
>> drivers/vhost/vsock.c:192:37: sparse: sparse: cast to restricted __le32

vim +192 drivers/vhost/vsock.c

    89	
    90	static void
    91	vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
    92				    struct vhost_virtqueue *vq)
    93	{
    94		struct vhost_virtqueue *tx_vq = &vsock->vqs[VSOCK_VQ_TX];
    95		int pkts = 0, total_len = 0;
    96		bool added = false;
    97		bool restart_tx = false;
    98	
    99		mutex_lock(&vq->mutex);
   100	
   101		if (!vhost_vq_get_backend(vq))
   102			goto out;
   103	
   104		if (!vq_meta_prefetch(vq))
   105			goto out;
   106	
   107		/* Avoid further vmexits, we're already processing the virtqueue */
   108		vhost_disable_notify(&vsock->dev, vq);
   109	
   110		do {
   111			struct virtio_vsock_pkt *pkt;
   112			struct iov_iter iov_iter;
   113			unsigned out, in;
   114			size_t nbytes;
   115			size_t iov_len, payload_len;
   116			int head;
   117			u32 flags_to_restore = 0;
   118	
   119			spin_lock_bh(&vsock->send_pkt_list_lock);
   120			if (list_empty(&vsock->send_pkt_list)) {
   121				spin_unlock_bh(&vsock->send_pkt_list_lock);
   122				vhost_enable_notify(&vsock->dev, vq);
   123				break;
   124			}
   125	
   126			pkt = list_first_entry(&vsock->send_pkt_list,
   127					       struct virtio_vsock_pkt, list);
   128			list_del_init(&pkt->list);
   129			spin_unlock_bh(&vsock->send_pkt_list_lock);
   130	
   131			head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
   132						 &out, &in, NULL, NULL);
   133			if (head < 0) {
   134				spin_lock_bh(&vsock->send_pkt_list_lock);
   135				list_add(&pkt->list, &vsock->send_pkt_list);
   136				spin_unlock_bh(&vsock->send_pkt_list_lock);
   137				break;
   138			}
   139	
   140			if (head == vq->num) {
   141				spin_lock_bh(&vsock->send_pkt_list_lock);
   142				list_add(&pkt->list, &vsock->send_pkt_list);
   143				spin_unlock_bh(&vsock->send_pkt_list_lock);
   144	
   145				/* We cannot finish yet if more buffers snuck in while
   146				 * re-enabling notify.
   147				 */
   148				if (unlikely(vhost_enable_notify(&vsock->dev, vq))) {
   149					vhost_disable_notify(&vsock->dev, vq);
   150					continue;
   151				}
   152				break;
   153			}
   154	
   155			if (out) {
   156				virtio_transport_free_pkt(pkt);
   157				vq_err(vq, "Expected 0 output buffers, got %u\n", out);
   158				break;
   159			}
   160	
   161			iov_len = iov_length(&vq->iov[out], in);
   162			if (iov_len < sizeof(pkt->hdr)) {
   163				virtio_transport_free_pkt(pkt);
   164				vq_err(vq, "Buffer len [%zu] too small\n", iov_len);
   165				break;
   166			}
   167	
   168			iov_iter_init(&iov_iter, READ, &vq->iov[out], in, iov_len);
   169			payload_len = pkt->len - pkt->off;
   170	
   171			/* If the packet is greater than the space available in the
   172			 * buffer, we split it using multiple buffers.
   173			 */
   174			if (payload_len > iov_len - sizeof(pkt->hdr)) {
   175				payload_len = iov_len - sizeof(pkt->hdr);
   176	
   177				/* As we are copying pieces of large packet's buffer to
   178				 * small rx buffers, headers of packets in rx queue are
   179				 * created dynamically and are initialized with header
   180				 * of current packet(except length). But in case of
   181				 * SOCK_SEQPACKET, we also must clear message delimeter
   182				 * bit (VIRTIO_VSOCK_SEQ_EOM) and MSG_EOR bit
   183				 * (VIRTIO_VSOCK_SEQ_EOR) if set. Otherwise,
   184				 * there will be sequence of packets with these
   185				 * bits set. After initialized header will be copied to
   186				 * rx buffer, these required bits will be restored.
   187				 */
   188				if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
   189					pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
   190					flags_to_restore |= VIRTIO_VSOCK_SEQ_EOM;
   191	
 > 192					if (le32_to_cpu(pkt->hdr.flags & VIRTIO_VSOCK_SEQ_EOR)) {
   193						pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
   194						flags_to_restore |= VIRTIO_VSOCK_SEQ_EOR;
   195					}
   196				}
   197			}
   198	
   199			/* Set the correct length in the header */
   200			pkt->hdr.len = cpu_to_le32(payload_len);
   201	
   202			nbytes = copy_to_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
   203			if (nbytes != sizeof(pkt->hdr)) {
   204				virtio_transport_free_pkt(pkt);
   205				vq_err(vq, "Faulted on copying pkt hdr\n");
   206				break;
   207			}
   208	
   209			nbytes = copy_to_iter(pkt->buf + pkt->off, payload_len,
   210					      &iov_iter);
   211			if (nbytes != payload_len) {
   212				virtio_transport_free_pkt(pkt);
   213				vq_err(vq, "Faulted on copying pkt buf\n");
   214				break;
   215			}
   216	
   217			/* Deliver to monitoring devices all packets that we
   218			 * will transmit.
   219			 */
   220			virtio_transport_deliver_tap_pkt(pkt);
   221	
   222			vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
   223			added = true;
   224	
   225			pkt->off += payload_len;
   226			total_len += payload_len;
   227	
   228			/* If we didn't send all the payload we can requeue the packet
   229			 * to send it with the next available buffer.
   230			 */
   231			if (pkt->off < pkt->len) {
   232				pkt->hdr.flags |= cpu_to_le32(flags_to_restore);
   233	
   234				/* We are queueing the same virtio_vsock_pkt to handle
   235				 * the remaining bytes, and we want to deliver it
   236				 * to monitoring devices in the next iteration.
   237				 */
   238				pkt->tap_delivered = false;
   239	
   240				spin_lock_bh(&vsock->send_pkt_list_lock);
   241				list_add(&pkt->list, &vsock->send_pkt_list);
   242				spin_unlock_bh(&vsock->send_pkt_list_lock);
   243			} else {
   244				if (pkt->reply) {
   245					int val;
   246	
   247					val = atomic_dec_return(&vsock->queued_replies);
   248	
   249					/* Do we have resources to resume tx
   250					 * processing?
   251					 */
   252					if (val + 1 == tx_vq->num)
   253						restart_tx = true;
   254				}
   255	
   256				virtio_transport_free_pkt(pkt);
   257			}
   258		} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
   259		if (added)
   260			vhost_signal(&vsock->dev, vq);
   261	
   262	out:
   263		mutex_unlock(&vq->mutex);
   264	
   265		if (restart_tx)
   266			vhost_poll_queue(&tx_vq->poll);
   267	}
   268	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--huq684BweRXVnRxX
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
DAIA

--huq684BweRXVnRxX--
