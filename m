Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74B8A103A20
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbfKTMfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:35:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57342 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729782AbfKTMfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:35:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKCY3H8079949;
        Wed, 20 Nov 2019 12:34:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=1mIC35+eNFMPCfiPugk21WBGXDV6EWboy/r9beQ7IHU=;
 b=MX188vRXVc2QXEjhjNw/5j+0TJ9/lJ+uRJp6Q8vFOQRYvVeVUlD7sWhV9yPXjeMprDS/
 G0c8l35MnoIj9K/udadA0AeEIIf680K4HvO9HOAFY/MrpmXzV881dIVgD8BSgkB/6Q+n
 PbryTvL4TopadcMJxx3e7UMsCYa3C8C4r9yXhSAsp1q32j+5RQJ2AWsW8NYPzdaJSFOH
 l9mOIFPJ9IOvvQaEXnfsywbh2Y+5JBf5Rqs8Hdvc7k/f5eZB35422bVS6QV5+NciJgQz
 iMmFTSEG3I4vzHZvYanQay9e/vhlxInki81HWL9zTFiGLmtF6FjwsaINWDJQOveFhSoh wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wa8htw9t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 12:34:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKCTFLB053490;
        Wed, 20 Nov 2019 12:34:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2wcemfj9d1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 12:34:56 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAKCYrar006458;
        Wed, 20 Nov 2019 12:34:54 GMT
Received: from kili.mountain (/41.210.147.113)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 04:34:51 -0800
Date:   Wed, 20 Nov 2019 15:34:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@mellanox.com>, David Ahern <dsahern@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Parav Pandit <parav@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: rtnetlink: prevent underflows in do_setvfinfo()
Message-ID: <20191120123438.vxn2ngnxzpcaqot4@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "ivm->vf" variable is a u32, but the problem is that a number of
drivers cast it to an int and then forget to check for negatives.  An
example of this is in the cxgb4 driver.

drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
  2890  static int cxgb4_mgmt_get_vf_config(struct net_device *dev,
  2891                                      int vf, struct ifla_vf_info *ivi)
                                            ^^^^^^
  2892  {
  2893          struct port_info *pi = netdev_priv(dev);
  2894          struct adapter *adap = pi->adapter;
  2895          struct vf_info *vfinfo;
  2896  
  2897          if (vf >= adap->num_vfs)
                    ^^^^^^^^^^^^^^^^^^^
  2898                  return -EINVAL;
  2899          vfinfo = &adap->vfinfo[vf];
                ^^^^^^^^^^^^^^^^^^^^^^^^^^

There are 48 functions affected.

drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c:8435 hclge_set_vf_vlan_filter() warn: can 'vfid' underflow 's32min-2147483646'
drivers/net/ethernet/freescale/enetc/enetc_pf.c:377 enetc_pf_set_vf_mac() warn: can 'vf' underflow 's32min-2147483646'
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:2899 cxgb4_mgmt_get_vf_config() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:2960 cxgb4_mgmt_set_vf_rate() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3019 cxgb4_mgmt_set_vf_rate() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3038 cxgb4_mgmt_set_vf_vlan() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3086 cxgb4_mgmt_set_vf_link_state() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/chelsio/cxgb/cxgb2.c:791 get_eeprom() warn: can 'i' underflow 's32min-(-4),0,4-s32max'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:82 bnxt_set_vf_spoofchk() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:164 bnxt_set_vf_trust() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:186 bnxt_get_vf_config() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:228 bnxt_set_vf_mac() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:264 bnxt_set_vf_vlan() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:293 bnxt_set_vf_bw() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:333 bnxt_set_vf_link_state() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:2595 bnx2x_vf_op_prep() warn: can 'vfidx' underflow 's32min-63'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:2595 bnx2x_vf_op_prep() warn: can 'vfidx' underflow 's32min-63'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c:2281 bnx2x_post_vf_bulletin() warn: can 'vf' underflow 's32min-63'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c:2285 bnx2x_post_vf_bulletin() warn: can 'vf' underflow 's32min-63'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c:2286 bnx2x_post_vf_bulletin() warn: can 'vf' underflow 's32min-63'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c:2292 bnx2x_post_vf_bulletin() warn: can 'vf' underflow 's32min-63'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c:2297 bnx2x_post_vf_bulletin() warn: can 'vf' underflow 's32min-63'
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c:1832 qlcnic_sriov_set_vf_mac() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c:1864 qlcnic_sriov_set_vf_tx_rate() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c:1937 qlcnic_sriov_set_vf_vlan() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c:2005 qlcnic_sriov_get_vf_config() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c:2036 qlcnic_sriov_set_vf_spoofchk() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/emulex/benet/be_main.c:1914 be_get_vf_config() warn: can 'vf' underflow 's32min-65534'
drivers/net/ethernet/emulex/benet/be_main.c:1915 be_get_vf_config() warn: can 'vf' underflow 's32min-65534'
drivers/net/ethernet/emulex/benet/be_main.c:1922 be_set_vf_tvt() warn: can 'vf' underflow 's32min-65534'
drivers/net/ethernet/emulex/benet/be_main.c:1951 be_clear_vf_tvt() warn: can 'vf' underflow 's32min-65534'
drivers/net/ethernet/emulex/benet/be_main.c:2063 be_set_vf_tx_rate() warn: can 'vf' underflow 's32min-65534'
drivers/net/ethernet/emulex/benet/be_main.c:2091 be_set_vf_link_state() warn: can 'vf' underflow 's32min-65534'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:2609 ice_set_vf_port_vlan() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:3050 ice_get_vf_cfg() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:3103 ice_set_vf_spoofchk() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:3181 ice_set_vf_mac() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:3237 ice_set_vf_trust() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:3286 ice_set_vf_link_state() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:3919 i40e_validate_vf() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:3957 i40e_ndo_set_vf_mac() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4104 i40e_ndo_set_vf_port_vlan() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4263 i40e_ndo_set_vf_bw() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4309 i40e_ndo_get_vf_config() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4371 i40e_ndo_set_vf_link_state() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4441 i40e_ndo_set_vf_spoofchk() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4441 i40e_ndo_set_vf_spoofchk() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4504 i40e_ndo_set_vf_trust() warn: can 'vf_id' underflow 's32min-2147483646'

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---

I reported this bug to the linux-rdma mailing list in April and this
patch wasn't considered very elegant.  I can see how that's true.  The
developer offered to write a fix which would update all the drivers to
use u32 throughout.  I reminded him in September that this bug still
needs to be fixed.

I think there may be security implications and this patch is easy to
backport to stable kernels so in that sense, it might be a better
approach.  Also this patch might prevent underflows in future drivers.

 net/core/rtnetlink.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 000eddb1207d..9f7aa448bd11 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2251,6 +2251,8 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 	if (tb[IFLA_VF_MAC]) {
 		struct ifla_vf_mac *ivm = nla_data(tb[IFLA_VF_MAC]);
 
+		if (ivm->vf >= INT_MAX)
+			return -EINVAL;
 		err = -EOPNOTSUPP;
 		if (ops->ndo_set_vf_mac)
 			err = ops->ndo_set_vf_mac(dev, ivm->vf,
@@ -2262,6 +2264,8 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 	if (tb[IFLA_VF_VLAN]) {
 		struct ifla_vf_vlan *ivv = nla_data(tb[IFLA_VF_VLAN]);
 
+		if (ivv->vf >= INT_MAX)
+			return -EINVAL;
 		err = -EOPNOTSUPP;
 		if (ops->ndo_set_vf_vlan)
 			err = ops->ndo_set_vf_vlan(dev, ivv->vf, ivv->vlan,
@@ -2294,6 +2298,8 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 		if (len == 0)
 			return -EINVAL;
 
+		if (ivvl[0]->vf >= INT_MAX)
+			return -EINVAL;
 		err = ops->ndo_set_vf_vlan(dev, ivvl[0]->vf, ivvl[0]->vlan,
 					   ivvl[0]->qos, ivvl[0]->vlan_proto);
 		if (err < 0)
@@ -2304,6 +2310,8 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 		struct ifla_vf_tx_rate *ivt = nla_data(tb[IFLA_VF_TX_RATE]);
 		struct ifla_vf_info ivf;
 
+		if (ivt->vf >= INT_MAX)
+			return -EINVAL;
 		err = -EOPNOTSUPP;
 		if (ops->ndo_get_vf_config)
 			err = ops->ndo_get_vf_config(dev, ivt->vf, &ivf);
@@ -2322,6 +2330,8 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 	if (tb[IFLA_VF_RATE]) {
 		struct ifla_vf_rate *ivt = nla_data(tb[IFLA_VF_RATE]);
 
+		if (ivt->vf >= INT_MAX)
+			return -EINVAL;
 		err = -EOPNOTSUPP;
 		if (ops->ndo_set_vf_rate)
 			err = ops->ndo_set_vf_rate(dev, ivt->vf,
@@ -2334,6 +2344,8 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 	if (tb[IFLA_VF_SPOOFCHK]) {
 		struct ifla_vf_spoofchk *ivs = nla_data(tb[IFLA_VF_SPOOFCHK]);
 
+		if (ivs->vf >= INT_MAX)
+			return -EINVAL;
 		err = -EOPNOTSUPP;
 		if (ops->ndo_set_vf_spoofchk)
 			err = ops->ndo_set_vf_spoofchk(dev, ivs->vf,
@@ -2345,6 +2357,8 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 	if (tb[IFLA_VF_LINK_STATE]) {
 		struct ifla_vf_link_state *ivl = nla_data(tb[IFLA_VF_LINK_STATE]);
 
+		if (ivl->vf >= INT_MAX)
+			return -EINVAL;
 		err = -EOPNOTSUPP;
 		if (ops->ndo_set_vf_link_state)
 			err = ops->ndo_set_vf_link_state(dev, ivl->vf,
@@ -2358,6 +2372,8 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 
 		err = -EOPNOTSUPP;
 		ivrssq_en = nla_data(tb[IFLA_VF_RSS_QUERY_EN]);
+		if (ivrssq_en->vf >= INT_MAX)
+			return -EINVAL;
 		if (ops->ndo_set_vf_rss_query_en)
 			err = ops->ndo_set_vf_rss_query_en(dev, ivrssq_en->vf,
 							   ivrssq_en->setting);
@@ -2368,6 +2384,8 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 	if (tb[IFLA_VF_TRUST]) {
 		struct ifla_vf_trust *ivt = nla_data(tb[IFLA_VF_TRUST]);
 
+		if (ivt->vf >= INT_MAX)
+			return -EINVAL;
 		err = -EOPNOTSUPP;
 		if (ops->ndo_set_vf_trust)
 			err = ops->ndo_set_vf_trust(dev, ivt->vf, ivt->setting);
@@ -2378,15 +2396,18 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 	if (tb[IFLA_VF_IB_NODE_GUID]) {
 		struct ifla_vf_guid *ivt = nla_data(tb[IFLA_VF_IB_NODE_GUID]);
 
+		if (ivt->vf >= INT_MAX)
+			return -EINVAL;
 		if (!ops->ndo_set_vf_guid)
 			return -EOPNOTSUPP;
-
 		return handle_vf_guid(dev, ivt, IFLA_VF_IB_NODE_GUID);
 	}
 
 	if (tb[IFLA_VF_IB_PORT_GUID]) {
 		struct ifla_vf_guid *ivt = nla_data(tb[IFLA_VF_IB_PORT_GUID]);
 
+		if (ivt->vf >= INT_MAX)
+			return -EINVAL;
 		if (!ops->ndo_set_vf_guid)
 			return -EOPNOTSUPP;
 
-- 
2.11.0

