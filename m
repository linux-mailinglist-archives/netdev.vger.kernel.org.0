Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF7B1B1AA9
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 02:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgDUA0Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Apr 2020 20:26:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:19848 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgDUA0Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 20:26:16 -0400
IronPort-SDR: 3mfeNt2lm5yMNik42qW6RkZXeNM6CSS7KqzJ90FLEipAjWIn7zh+7gc6UKpiB3m0ZXdZHCP3Ip
 fdGNutRhw/ag==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 17:26:15 -0700
IronPort-SDR: tvJpzVhtKaoOOuhQ1jY2SSF9WaoomzEMH7eIbWgy+8fFADh2ezxSg6RKsLZ+r9C/FWu2K4EAof
 vsZPYDdzFFFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="402011838"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga004.jf.intel.com with ESMTP; 20 Apr 2020 17:26:15 -0700
Received: from fmsmsx156.amr.corp.intel.com (10.18.116.74) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Apr 2020 17:26:14 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.70]) by
 fmsmsx156.amr.corp.intel.com ([169.254.13.73]) with mapi id 14.03.0439.000;
 Mon, 20 Apr 2020 17:26:14 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [RFC PATCH v5 07/16] RDMA/irdma: Add connection manager
Thread-Topic: [RFC PATCH v5 07/16] RDMA/irdma: Add connection manager
Thread-Index: AQHWFNtwRTD3fFrqokm8Ki8CNZ7Pj6h+N8IAgAQQvIA=
Date:   Tue, 21 Apr 2020 00:26:14 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7DCD4858B@fmsmsx124.amr.corp.intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-8-jeffrey.t.kirsher@intel.com>
 <20200417202332.GG3083@unreal>
In-Reply-To: <20200417202332.GG3083@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RFC PATCH v5 07/16] RDMA/irdma: Add connection manager
> 
> On Fri, Apr 17, 2020 at 10:12:42AM -0700, Jeff Kirsher wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Add connection management (CM) implementation for iWARP including
> > accept, reject, connect, create_listen, destroy_listen and CM utility
> > functions
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---
> >  drivers/infiniband/hw/irdma/cm.c | 4499
> > ++++++++++++++++++++++++++++++  drivers/infiniband/hw/irdma/cm.h |
> > 413 +++
> >  2 files changed, 4912 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/irdma/cm.c  create mode
> > 100644 drivers/infiniband/hw/irdma/cm.h
> >
> > diff --git a/drivers/infiniband/hw/irdma/cm.c
> > b/drivers/infiniband/hw/irdma/cm.c
> > new file mode 100644
> > index 000000000000..87d6300fee35
> > --- /dev/null
> > +++ b/drivers/infiniband/hw/irdma/cm.c
> > @@ -0,0 +1,4499 @@
> > +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> > +/* Copyright (c) 2015 - 2019 Intel Corporation */ #include
> > +<linux/highmem.h> #include <net/addrconf.h> #include
> > +<net/ip6_route.h> #include <net/flow.h> #include <net/secure_seq.h>
> > +
> > +#include "main.h"
> > +#include "trace.h"
> > +
> > +static void irdma_rem_ref_cm_node(struct irdma_cm_node *); static
> > +void irdma_cm_post_event(struct irdma_cm_event *event); static void
> > +irdma_disconnect_worker(struct work_struct *work);
> > +
> > +/**
> > + * irdma_free_sqbuf - put back puda buffer if refcount is 0
> > + * @vsi: The VSI structure of the device
> > + * @bufp: puda buffer to free
> > + */
> > +void irdma_free_sqbuf(struct irdma_sc_vsi *vsi, void *bufp) {
> > +	struct irdma_puda_buf *buf = bufp;
> > +	struct irdma_puda_rsrc *ilq = vsi->ilq;
> > +
> > +	if (refcount_dec_and_test(&buf->refcount))
> > +		irdma_puda_ret_bufpool(ilq, buf);
> > +}
> > +
> > +/**
> > + * irdma_derive_hw_ird_setting - Calculate IRD
> > + * @cm_ird: IRD of connection's node
> > + *
> > + * The ird from the connection is rounded to a supported HW
> > + * setting (2,8,32,64,128) and then encoded for ird_size field
> > + * of qp_ctx
> > + */
> > +u8 irdma_derive_hw_ird_setting(u16 cm_ird) {
> > +	/* ird_size field is encoded in qp_ctx */
> > +	switch (cm_ird ? roundup_pow_of_two(cm_ird) : 0) {
> > +	case IRDMA_HW_IRD_SETTING_128:
> > +		return 4;
> > +	case IRDMA_HW_IRD_SETTING_64:
> > +		return 3;
> > +	case IRDMA_HW_IRD_SETTING_32:
> > +	case IRDMA_HW_IRD_SETTING_16:
> > +		return 2;
> > +	case IRDMA_HW_IRD_SETTING_8:
> > +	case IRDMA_HW_IRD_SETTING_4:
> > +		return 1;
> > +	case IRDMA_HW_IRD_SETTING_2:
> > +	default:
> > +		break;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * irdma_record_ird_ord - Record IRD/ORD passed in
> > + * @cm_node: connection's node
> > + * @conn_ird: connection IRD
> > + * @conn_ord: connection ORD
> > + */
> > +static void irdma_record_ird_ord(struct irdma_cm_node *cm_node, u32
> conn_ird,
> > +				 u32 conn_ord)
> > +{
> > +	if (conn_ird > cm_node->dev->hw_attrs.max_hw_ird)
> > +		conn_ird = cm_node->dev->hw_attrs.max_hw_ird;
> > +
> > +	if (conn_ord > cm_node->dev->hw_attrs.max_hw_ord)
> > +		conn_ord = cm_node->dev->hw_attrs.max_hw_ord;
> > +	else if (!conn_ord && cm_node->send_rdma0_op ==
> SEND_RDMA_READ_ZERO)
> > +		conn_ord = 1;
> > +	cm_node->ird_size = conn_ird;
> > +	cm_node->ord_size = conn_ord;
> > +}
> > +
> > +/**
> > + * irdma_copy_ip_ntohl - copy IP address from  network to host
> > + * @dst: IP address in host order
> > + * @src: IP address in network order (big endian)  */ void
> > +irdma_copy_ip_ntohl(u32 *dst, __be32 *src) {
> > +	*dst++ = ntohl(*src++);
> > +	*dst++ = ntohl(*src++);
> > +	*dst++ = ntohl(*src++);
> > +	*dst = ntohl(*src);
> > +}
> > +
> > +/**
> > + * irdma_copy_ip_htonl - copy IP address from host to network order
> > + * @dst: IP address in network order (big endian)
> > + * @src: IP address in host order
> > + */
> > +void irdma_copy_ip_htonl(__be32 *dst, u32 *src) {
> > +	*dst++ = htonl(*src++);
> > +	*dst++ = htonl(*src++);
> > +	*dst++ = htonl(*src++);
> > +	*dst = htonl(*src);
> > +}
> 
> It is strange that we don't have in the kernel some generic function to do it.
> 
> > +
> > +/**
> > + * irdma_get_addr_info
> > + * @cm_node: contains ip/tcp info
> > + * @cm_info: to get a copy of the cm_node ip/tcp info  */ static void
> > +irdma_get_addr_info(struct irdma_cm_node *cm_node,
> > +				struct irdma_cm_info *cm_info)
> > +{
> > +	memset(cm_info, 0, sizeof(*cm_info));
> > +	cm_info->ipv4 = cm_node->ipv4;
> > +	cm_info->vlan_id = cm_node->vlan_id;
> > +	memcpy(cm_info->loc_addr, cm_node->loc_addr, sizeof(cm_info-
> >loc_addr));
> > +	memcpy(cm_info->rem_addr, cm_node->rem_addr, sizeof(cm_info-
> >rem_addr));
> > +	cm_info->loc_port = cm_node->loc_port;
> > +	cm_info->rem_port = cm_node->rem_port; }
> > +
> > +/**
> > + * irdma_fill_sockaddr4 - fill in addr info for IPv4 connection
> > + * @cm_node: connection's node
> > + * @event: upper layer's cm event
> > + */
> > +static inline void irdma_fill_sockaddr4(struct irdma_cm_node *cm_node,
> > +					struct iw_cm_event *event)
> > +{
> > +	struct sockaddr_in *laddr = (struct sockaddr_in *)&event->local_addr;
> > +	struct sockaddr_in *raddr = (struct sockaddr_in
> > +*)&event->remote_addr;
> > +
> > +	laddr->sin_family = AF_INET;
> > +	raddr->sin_family = AF_INET;
> > +
> > +	laddr->sin_port = htons(cm_node->loc_port);
> > +	raddr->sin_port = htons(cm_node->rem_port);
> > +
> > +	laddr->sin_addr.s_addr = htonl(cm_node->loc_addr[0]);
> > +	raddr->sin_addr.s_addr = htonl(cm_node->rem_addr[0]); }
> > +
> > +/**
> > + * irdma_fill_sockaddr6 - fill in addr info for IPv6 connection
> > + * @cm_node: connection's node
> > + * @event: upper layer's cm event
> > + */
> > +static inline void irdma_fill_sockaddr6(struct irdma_cm_node *cm_node,
> > +					struct iw_cm_event *event)
> > +{
> > +	struct sockaddr_in6 *laddr6 = (struct sockaddr_in6 *)&event->local_addr;
> > +	struct sockaddr_in6 *raddr6 = (struct sockaddr_in6
> > +*)&event->remote_addr;
> > +
> > +	laddr6->sin6_family = AF_INET6;
> > +	raddr6->sin6_family = AF_INET6;
> > +
> > +	laddr6->sin6_port = htons(cm_node->loc_port);
> > +	raddr6->sin6_port = htons(cm_node->rem_port);
> > +
> > +	irdma_copy_ip_htonl(laddr6->sin6_addr.in6_u.u6_addr32,
> > +			    cm_node->loc_addr);
> > +	irdma_copy_ip_htonl(raddr6->sin6_addr.in6_u.u6_addr32,
> > +			    cm_node->rem_addr);
> > +}
> > +
> > +/**
> > + * irdma_get_cmevent_info - for cm event upcall
> > + * @cm_node: connection's node
> > + * @cm_id: upper layers cm struct for the event
> > + * @event: upper layer's cm event
> > + */
> > +static inline void irdma_get_cmevent_info(struct irdma_cm_node *cm_node,
> > +					  struct iw_cm_id *cm_id,
> > +					  struct iw_cm_event *event)
> > +{
> > +	memcpy(&event->local_addr, &cm_id->m_local_addr,
> > +	       sizeof(event->local_addr));
> > +	memcpy(&event->remote_addr, &cm_id->m_remote_addr,
> > +	       sizeof(event->remote_addr));
> > +	if (cm_node) {
> > +		event->private_data = cm_node->pdata_buf;
> > +		event->private_data_len = (u8)cm_node->pdata.size;
> > +		event->ird = cm_node->ird_size;
> > +		event->ord = cm_node->ord_size;
> > +	}
> > +}
> > +
> > +/**
> > + * irdma_send_cm_event - upcall cm's event handler
> > + * @cm_node: connection's node
> > + * @cm_id: upper layer's cm info struct
> > + * @type: Event type to indicate
> > + * @status: status for the event type  */ static int
> > +irdma_send_cm_event(struct irdma_cm_node *cm_node,
> > +			       struct iw_cm_id *cm_id,
> > +			       enum iw_cm_event_type type, int status) {
> > +	struct iw_cm_event event = {};
> > +
> > +	event.event = type;
> > +	event.status = status;
> > +	switch (type) {
> > +	case IW_CM_EVENT_CONNECT_REQUEST:
> > +		trace_irdma_send_cm_event(cm_node, cm_id, type, status,
> > +					  __builtin_return_address(0));
> > +		if (cm_node->ipv4)
> > +			irdma_fill_sockaddr4(cm_node, &event);
> > +		else
> > +			irdma_fill_sockaddr6(cm_node, &event);
> > +		event.provider_data = cm_node;
> > +		event.private_data = cm_node->pdata_buf;
> > +		event.private_data_len = (u8)cm_node->pdata.size;
> > +		event.ird = cm_node->ird_size;
> > +		break;
> > +	case IW_CM_EVENT_CONNECT_REPLY:
> > +		trace_irdma_send_cm_event(cm_node, cm_id, type, status,
> > +					  __builtin_return_address(0));
> > +		irdma_get_cmevent_info(cm_node, cm_id, &event);
> > +		break;
> > +	case IW_CM_EVENT_ESTABLISHED:
> > +		trace_irdma_send_cm_event(cm_node, cm_id, type, status,
> > +					  __builtin_return_address(0));
> > +		event.ird = cm_node->ird_size;
> > +		event.ord = cm_node->ord_size;
> > +		break;
> > +	case IW_CM_EVENT_DISCONNECT:
> > +		trace_irdma_send_cm_event_no_node(cm_id, type, status,
> > +						  __builtin_return_address(0));
> > +		break;
> > +	case IW_CM_EVENT_CLOSE:
> > +		trace_irdma_send_cm_event_no_node(cm_id, type, status,
> > +						  __builtin_return_address(0));
> > +		break;
> > +	default:
> > +		ibdev_dbg(to_ibdev(cm_node->iwdev),
> > +			  "CM: Unsupported event type received type = %d\n",
> > +			  type);
> > +		return -1;
> 
> How are these trace events different from existing in IB/core and why should driver
> implement CM event handler? Is it iWARP specific?
> 
> I'm really worried to see CM code in the driver.
> 

Yes the CM code in the driver is iWARP specific
https://elixir.bootlin.com/linux/v5.7-rc2/source/include/rdma/iw_cm.h#L72
https://elixir.bootlin.com/linux/v5.7-rc2/source/include/rdma/ib_verbs.h#L2566

We have some CM tracing to record driver specific data / paths in connection
flows. For example in this patch we record,

+	    TP_printk("iwdev=%p  caller=%pS  cm_id=%p  node=%p  refcnt=%d  vlan_id=%d  accel=%d  state=%s  event_type=%s  status=%d  loc: %s  rem: %s",
+		      __entry->iwdev,
+		      __entry->caller,
+		      __entry->cm_id,
+		      __entry->cm_node,
+		      __entry->refcount,
+		      __entry->vlan_id,
+		      __entry->accel,
+		      parse_cm_state(__entry->state),
+		      parse_iw_event_type(__entry->type),
+		      __entry->status,
+		      __print_ip_addr(__get_dynamic_array(laddr),
+				      __entry->lport, __entry->ipv4),
+		      __print_ip_addr(__get_dynamic_array(raddr),
+				      __entry->rport, __entry->ipv4)
+		    )
+);
