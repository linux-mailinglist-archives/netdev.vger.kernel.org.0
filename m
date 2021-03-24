Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1981C3471F9
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 08:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhCXHCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 03:02:11 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39556 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhCXHB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 03:01:57 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12O6sLj3178940;
        Wed, 24 Mar 2021 07:01:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=XFMxzi+NwiEs6PGuO5k4bXoYxJcbeZlb5MBjasEVd2E=;
 b=N6reE0m9K16sJ5o5jOlvOt6FzaJgegCJwS/qvIyYLEb+Daskb5Ui74qYhwW+OhIWQc+x
 3YYUdPijBq7PqeypO2ysq90F77fgUkitOWmS/D08VgivhAjHqZlhlvjYBFwiX+862nr0
 imqcgXu+L0JCQQAW4CK84z82Tn8Rw/AaYMHLiv+qZFXNiYUzWmN3NYn9Y/Yjql0JhYkb
 vQDpn6MdN82FiXBqsSPC2H1HGSjbhrH8YW9VrdKtWP/ajTo+bIBoYBmPymrXNJyYeh/C
 90EeD85AFKSoYabDz+6klBE+a4c4VHFf4JoesLXhxTZPvs7W3yd1rsmztlYoMt/AkCmV Mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37d6jbhqx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 07:01:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12O6uQw8099794;
        Wed, 24 Mar 2021 07:01:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 37dty07ta4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 07:01:50 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 12O71na1016432;
        Wed, 24 Mar 2021 07:01:49 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Mar 2021 00:01:48 -0700
Date:   Wed, 24 Mar 2021 10:01:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     shenjian15@huawei.com
Cc:     netdev@vger.kernel.org
Subject: [bug report] net: hns3: vf indexing in hclge_add_fd_entry()
Message-ID: <YFrj1qbwIxrAo+jk@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103240053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1011 priorityscore=1501
 spamscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103240053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jian Shen,

The patch 5f2b1238b33c: "net: hns3: refactor out
hclge_add_fd_entry()" from Mar 22, 2021, leads to the following
static checker warning:

	drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c:6512 hclge_fd_parse_ring_cookie()
	warn: array off by one? 'hdev->vport[vf]'

drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
  6493  static int hclge_fd_parse_ring_cookie(struct hclge_dev *hdev, u64 ring_cookie,
  6494                                        u16 *vport_id, u8 *action, u16 *queue_id)
  6495  {
  6496          struct hclge_vport *vport = hdev->vport;
  6497  
  6498          if (ring_cookie == RX_CLS_FLOW_DISC) {
  6499                  *action = HCLGE_FD_ACTION_DROP_PACKET;
  6500          } else {
  6501                  u32 ring = ethtool_get_flow_spec_ring(ring_cookie);
  6502                  u8 vf = ethtool_get_flow_spec_ring_vf(ring_cookie);
  6503                  u16 tqps;
  6504  
  6505                  if (vf > hdev->num_req_vfs) {
                            ^^^^^^^^^^^^^^^^^^^^^^

The is off by one but checking hdev->num_req_vfs in this context doesn't
make sense.  Should it instead be check hdev->num_alloc_vport?  Also
should we add HCLGE_VF_VPORT_START_NUM?

		vf = ethtool_get_flow_spec_ring_vf(ring_cookie);
		vf += HCLGE_VF_VPORT_START_NUM;
		if (vf >= hdev->num_alloc_vport)
			return -EINVAL;

  6506                          dev_err(&hdev->pdev->dev,
  6507                                  "Error: vf id (%u) > max vf num (%u)\n",
                                                           ^^
Use >=

  6508                                  vf, hdev->num_req_vfs);
  6509                          return -EINVAL;
  6510                  }
  6511  
  6512                  *vport_id = vf ? hdev->vport[vf].vport_id : vport->vport_id;
                                               ^^^^^^^^^
  6513                  tqps = hdev->vport[vf].nic.kinfo.num_tqps;
                                          ^^^
The vport array has hdev->num_vmdq_vport + hdev->num_req_vfs + 1;
elements.  ->vport[0] is tqp_main_vport.  The next elements are
hdev->num_vmdq_vport and the last part of the array is hdev->num_req_vfs.

Another possibility is that perhaps this is what was intended?

			idx = vf + 1 + hdev->num_vmdq_vport;

			*vport_id = vf ? vport[idx].vport_id : vport[0].vport_id;
			tqps = vport[idx].nic.kinfo.num_tqps;

There is related code that offers clues but I'm not sure what to do.

  6514  
  6515                  if (ring >= tqps) {
  6516                          dev_err(&hdev->pdev->dev,
  6517                                  "Error: queue id (%u) > max tqp num (%u)\n",
  6518                                  ring, tqps - 1);
  6519                          return -EINVAL;
  6520                  }
  6521  
  6522                  *action = HCLGE_FD_ACTION_SELECT_QUEUE;
  6523                  *queue_id = ring;
  6524          }
  6525  
  6526          return 0;
  6527  }

[ snip ]

  9111  static bool hclge_check_vf_mac_exist(struct hclge_vport *vport, int vf_idx,
  9112                                       u8 *mac_addr)
  9113  {
  9114          struct hclge_mac_vlan_tbl_entry_cmd req;
  9115          struct hclge_dev *hdev = vport->back;
  9116          struct hclge_desc desc;
  9117          u16 egress_port = 0;
  9118          int i;
  9119  
  9120          if (is_zero_ether_addr(mac_addr))
  9121                  return false;
  9122  
  9123          memset(&req, 0, sizeof(req));
  9124          hnae3_set_field(egress_port, HCLGE_MAC_EPORT_VFID_M,
  9125                          HCLGE_MAC_EPORT_VFID_S, vport->vport_id);
  9126          req.egress_port = cpu_to_le16(egress_port);
  9127          hclge_prepare_mac_addr(&req, mac_addr, false);
  9128  
  9129          if (hclge_lookup_mac_vlan_tbl(vport, &req, &desc, false) != -ENOENT)
  9130                  return true;
  9131  
  9132          vf_idx += HCLGE_VF_VPORT_START_NUM;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We're are skipping the first element.  Should it instead be?:

	vf_idx += hdev->num_vmdq_vport + 1;

  9133          for (i = hdev->num_vmdq_vport + 1; i < hdev->num_alloc_vport; i++)
                         ^^^^^^^^^^^^^^^^^^^^^^^^
We're only checking the last part of the array.

  9134                  if (i != vf_idx &&
  9135                      ether_addr_equal(mac_addr, hdev->vport[i].vf_info.mac))
  9136                          return true;
  9137  
  9138          return false;
  9139  }

Another thing that's not clear to me is how pci_num_vf() relates to
this.  I suspect that it is the same as hdev->num_vmdq_vport, but I
can't be sure.

regards,
dan carpenter
