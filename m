Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55203477AA
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 12:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhCXLsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 07:48:01 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14461 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhCXLr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 07:47:59 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F55yj5ZpVzwQNq;
        Wed, 24 Mar 2021 19:45:33 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.498.0; Wed, 24 Mar 2021
 19:47:23 +0800
Subject: Re: [bug report] net: hns3: vf indexing in hclge_add_fd_entry()
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <patrick.dengpeng@huawei.com>
References: <YFrj1qbwIxrAo+jk@mwanda>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <d4ae2398-f3bf-367c-231e-371729a87415@huawei.com>
Date:   Wed, 24 Mar 2021 19:47:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <YFrj1qbwIxrAo+jk@mwanda>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dan,

Thanks for your  report!


在 2021/3/24 15:01, Dan Carpenter 写道:
> Hello Jian Shen,
>
> The patch 5f2b1238b33c: "net: hns3: refactor out
> hclge_add_fd_entry()" from Mar 22, 2021, leads to the following
> static checker warning:
>
> 	drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c:6512 hclge_fd_parse_ring_cookie()
> 	warn: array off by one? 'hdev->vport[vf]'
>
> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>    6493  static int hclge_fd_parse_ring_cookie(struct hclge_dev *hdev, u64 ring_cookie,
>    6494                                        u16 *vport_id, u8 *action, u16 *queue_id)
>    6495  {
>    6496          struct hclge_vport *vport = hdev->vport;
>    6497
>    6498          if (ring_cookie == RX_CLS_FLOW_DISC) {
>    6499                  *action = HCLGE_FD_ACTION_DROP_PACKET;
>    6500          } else {
>    6501                  u32 ring = ethtool_get_flow_spec_ring(ring_cookie);
>    6502                  u8 vf = ethtool_get_flow_spec_ring_vf(ring_cookie);
>    6503                  u16 tqps;
>    6504
>    6505                  if (vf > hdev->num_req_vfs) {
>                              ^^^^^^^^^^^^^^^^^^^^^^
>
> The is off by one but checking hdev->num_req_vfs in this context doesn't
> make sense.  Should it instead be check hdev->num_alloc_vport?  Also
> should we add HCLGE_VF_VPORT_START_NUM?
>
> 		vf = ethtool_get_flow_spec_ring_vf(ring_cookie);
> 		vf += HCLGE_VF_VPORT_START_NUM;
> 		if (vf >= hdev->num_alloc_vport)
> 			return -EINVAL;
>
>    6506                          dev_err(&hdev->pdev->dev,
>    6507                                  "Error: vf id (%u) > max vf num (%u)\n",
>                                                             ^^
> Use >=
>
>    6508                                  vf, hdev->num_req_vfs);
>    6509                          return -EINVAL;
>    6510                  }
>    6511
>    6512                  *vport_id = vf ? hdev->vport[vf].vport_id : vport->vport_id;
>                                                 ^^^^^^^^^
>    6513                  tqps = hdev->vport[vf].nic.kinfo.num_tqps;
>                                            ^^^
> The vport array has hdev->num_vmdq_vport + hdev->num_req_vfs + 1;
> elements.  ->vport[0] is tqp_main_vport.  The next elements are
> hdev->num_vmdq_vport and the last part of the array is hdev->num_req_vfs.
>
> Another possibility is that perhaps this is what was intended?
>
> 			idx = vf + 1 + hdev->num_vmdq_vport;
>
> 			*vport_id = vf ? vport[idx].vport_id : vport[0].vport_id;
> 			tqps = vport[idx].nic.kinfo.num_tqps;
>
> There is related code that offers clues but I'm not sure what to do.
>
>    6514
>    6515                  if (ring >= tqps) {
>    6516                          dev_err(&hdev->pdev->dev,
>    6517                                  "Error: queue id (%u) > max tqp num (%u)\n",
>    6518                                  ring, tqps - 1);
>    6519                          return -EINVAL;
>    6520                  }
>    6521
>    6522                  *action = HCLGE_FD_ACTION_SELECT_QUEUE;
>    6523                  *queue_id = ring;
>    6524          }
>    6525
>    6526          return 0;
>    6527  }
>
> [ snip ]
>
>    9111  static bool hclge_check_vf_mac_exist(struct hclge_vport *vport, int vf_idx,
>    9112                                       u8 *mac_addr)
>    9113  {
>    9114          struct hclge_mac_vlan_tbl_entry_cmd req;
>    9115          struct hclge_dev *hdev = vport->back;
>    9116          struct hclge_desc desc;
>    9117          u16 egress_port = 0;
>    9118          int i;
>    9119
>    9120          if (is_zero_ether_addr(mac_addr))
>    9121                  return false;
>    9122
>    9123          memset(&req, 0, sizeof(req));
>    9124          hnae3_set_field(egress_port, HCLGE_MAC_EPORT_VFID_M,
>    9125                          HCLGE_MAC_EPORT_VFID_S, vport->vport_id);
>    9126          req.egress_port = cpu_to_le16(egress_port);
>    9127          hclge_prepare_mac_addr(&req, mac_addr, false);
>    9128
>    9129          if (hclge_lookup_mac_vlan_tbl(vport, &req, &desc, false) != -ENOENT)
>    9130                  return true;
>    9131
>    9132          vf_idx += HCLGE_VF_VPORT_START_NUM;
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> We're are skipping the first element.  Should it instead be?:
>
> 	vf_idx += hdev->num_vmdq_vport + 1;
>
>    9133          for (i = hdev->num_vmdq_vport + 1; i < hdev->num_alloc_vport; i++)
>                           ^^^^^^^^^^^^^^^^^^^^^^^^
> We're only checking the last part of the array.
>
>    9134                  if (i != vf_idx &&
>    9135                      ether_addr_equal(mac_addr, hdev->vport[i].vf_info.mac))
>    9136                          return true;
>    9137
>    9138          return false;
>    9139  }
>
> Another thing that's not clear to me is how pci_num_vf() relates to
> this.  I suspect that it is the same as hdev->num_vmdq_vport, but I
> can't be sure.
>
> regards,
> dan carpenter
> .
The use for num_vmdq_vport is confusing. At the beginning, the HNS3 
driver is planed to support
VMDQ . Whereafter the hardware supports SR-IOV with better performance. 
So VMDQ feature is
discarded,  but the codes of vmdq is remained. For the value of 
num_vmdq_vport is always 0, so the
vport id of VF is actually start from 1. That's why the driver still work.

As the num_vmdq_vport is actually useless and confusing, I will send a 
patch to remove it soon.

regards,
Jian Shen



