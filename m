Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82C5716A64C
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 13:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgBXMiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 07:38:11 -0500
Received: from mga06.intel.com ([134.134.136.31]:49988 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727450AbgBXMiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 07:38:10 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 04:38:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,480,1574150400"; 
   d="gz'50?scan'50,208,50";a="284344251"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Feb 2020 04:38:05 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1j6Czs-000DEO-RN; Mon, 24 Feb 2020 20:38:04 +0800
Date:   Mon, 24 Feb 2020 20:37:13 +0800
From:   kbuild test robot <lkp@intel.com>
To:     anton.ivanov@cambridgegreys.com
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-um@lists.infradead.org, mst@redhat.com, jasowang@redhat.com,
        eric.dumazet@gmail.com,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>
Subject: Re: [PATCH v2] virtio: Work around frames incorrectly marked as gso
Message-ID: <202002242010.iS7IWW8N%lkp@intel.com>
References: <20200224101912.14074-1-anton.ivanov@cambridgegreys.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20200224101912.14074-1-anton.ivanov@cambridgegreys.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I love your patch! Perhaps something to improve:

[auto build test WARNING on vhost/linux-next]
[also build test WARNING on linus/master ipvs/master v5.6-rc3 next-20200224]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/anton-ivanov-cambridgegreys-com/virtio-Work-around-frames-incorrectly-marked-as-gso/20200224-190342
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
config: nds32-defconfig (attached as .config)
compiler: nds32le-linux-gcc (GCC) 9.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=9.2.0 make.cross ARCH=nds32 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from net/packet/af_packet.c:82:
   include/linux/virtio_net.h: In function 'virtio_net_hdr_from_skb':
>> include/linux/virtio_net.h:103:2: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
     103 |  struct skb_shared_info *sinfo = skb_shinfo(skb);
         |  ^~~~~~

vim +103 include/linux/virtio_net.h

fd2a0437dc33b6 Mike Rapoport    2016-06-08   94  
fd2a0437dc33b6 Mike Rapoport    2016-06-08   95  static inline int virtio_net_hdr_from_skb(const struct sk_buff *skb,
fd2a0437dc33b6 Mike Rapoport    2016-06-08   96  					  struct virtio_net_hdr *hdr,
6391a4481ba079 Jason Wang       2017-01-20   97  					  bool little_endian,
fd3a8862584490 Willem de Bruijn 2018-06-06   98  					  bool has_data_valid,
fd3a8862584490 Willem de Bruijn 2018-06-06   99  					  int vlan_hlen)
fd2a0437dc33b6 Mike Rapoport    2016-06-08  100  {
9403cd7cbb08aa Jarno Rajahalme  2016-11-18  101  	memset(hdr, 0, sizeof(*hdr));   /* no info leak */
fd2a0437dc33b6 Mike Rapoport    2016-06-08  102  
fd2a0437dc33b6 Mike Rapoport    2016-06-08 @103  	struct skb_shared_info *sinfo = skb_shinfo(skb);
3d2c1fd2739938 Anton Ivanov     2020-02-24  104  	if (skb_is_gso(skb) && sinfo->gso_type) {
fd2a0437dc33b6 Mike Rapoport    2016-06-08  105  
fd2a0437dc33b6 Mike Rapoport    2016-06-08  106  		/* This is a hint as to how much should be linear. */
fd2a0437dc33b6 Mike Rapoport    2016-06-08  107  		hdr->hdr_len = __cpu_to_virtio16(little_endian,
fd2a0437dc33b6 Mike Rapoport    2016-06-08  108  						 skb_headlen(skb));
fd2a0437dc33b6 Mike Rapoport    2016-06-08  109  		hdr->gso_size = __cpu_to_virtio16(little_endian,
fd2a0437dc33b6 Mike Rapoport    2016-06-08  110  						  sinfo->gso_size);
fd2a0437dc33b6 Mike Rapoport    2016-06-08  111  		if (sinfo->gso_type & SKB_GSO_TCPV4)
fd2a0437dc33b6 Mike Rapoport    2016-06-08  112  			hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
fd2a0437dc33b6 Mike Rapoport    2016-06-08  113  		else if (sinfo->gso_type & SKB_GSO_TCPV6)
fd2a0437dc33b6 Mike Rapoport    2016-06-08  114  			hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
fd2a0437dc33b6 Mike Rapoport    2016-06-08  115  		else
fd2a0437dc33b6 Mike Rapoport    2016-06-08  116  			return -EINVAL;
fd2a0437dc33b6 Mike Rapoport    2016-06-08  117  		if (sinfo->gso_type & SKB_GSO_TCP_ECN)
fd2a0437dc33b6 Mike Rapoport    2016-06-08  118  			hdr->gso_type |= VIRTIO_NET_HDR_GSO_ECN;
fd2a0437dc33b6 Mike Rapoport    2016-06-08  119  	} else
fd2a0437dc33b6 Mike Rapoport    2016-06-08  120  		hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
fd2a0437dc33b6 Mike Rapoport    2016-06-08  121  
fd2a0437dc33b6 Mike Rapoport    2016-06-08  122  	if (skb->ip_summed == CHECKSUM_PARTIAL) {
fd2a0437dc33b6 Mike Rapoport    2016-06-08  123  		hdr->flags = VIRTIO_NET_HDR_F_NEEDS_CSUM;
fd2a0437dc33b6 Mike Rapoport    2016-06-08  124  		hdr->csum_start = __cpu_to_virtio16(little_endian,
fd3a8862584490 Willem de Bruijn 2018-06-06  125  			skb_checksum_start_offset(skb) + vlan_hlen);
fd2a0437dc33b6 Mike Rapoport    2016-06-08  126  		hdr->csum_offset = __cpu_to_virtio16(little_endian,
fd2a0437dc33b6 Mike Rapoport    2016-06-08  127  				skb->csum_offset);
6391a4481ba079 Jason Wang       2017-01-20  128  	} else if (has_data_valid &&
6391a4481ba079 Jason Wang       2017-01-20  129  		   skb->ip_summed == CHECKSUM_UNNECESSARY) {
6391a4481ba079 Jason Wang       2017-01-20  130  		hdr->flags = VIRTIO_NET_HDR_F_DATA_VALID;
fd2a0437dc33b6 Mike Rapoport    2016-06-08  131  	} /* else everything is zero */
fd2a0437dc33b6 Mike Rapoport    2016-06-08  132  
fd2a0437dc33b6 Mike Rapoport    2016-06-08  133  	return 0;
fd2a0437dc33b6 Mike Rapoport    2016-06-08  134  }
fd2a0437dc33b6 Mike Rapoport    2016-06-08  135  

:::::: The code at line 103 was first introduced by commit
:::::: fd2a0437dc33b6425cabf74cc7fc7fdba6d5903b virtio_net: introduce virtio_net_hdr_{from,to}_skb

:::::: TO: Mike Rapoport <rppt@linux.vnet.ibm.com>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--gKMricLos+KVdGMg
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--gKMricLos+KVdGMg--
