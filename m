Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A146611846
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 13:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfEBLnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 07:43:00 -0400
Received: from mga05.intel.com ([192.55.52.43]:27078 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfEBLm7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 07:42:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 04:42:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="154123104"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 02 May 2019 04:42:58 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hMA77-0006iq-In; Thu, 02 May 2019 19:42:57 +0800
Date:   Thu, 2 May 2019 19:42:32 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     kbuild-all@01.org, davem@davemloft.net,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 6/7] net: Rename skb_frag_t size to bv_len
Message-ID: <201905021922.T6BdffQh%lkp@intel.com>
References: <20190501144457.7942-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190501144457.7942-7-willy@infradead.org>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matthew,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on v5.1-rc7]
[cannot apply to next-20190501]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Matthew-Wilcox/Convert-skb_frag_t-to-bio_vec/20190502-161948
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/crypto/chelsio/chtls/chtls_io.c:1140:62: sparse: sparse: no member 'size' in struct skb_frag_struct
   drivers/crypto/chelsio/chtls/chtls_io.c:1253:54: sparse: sparse: no member 'size' in struct skb_frag_struct
>> drivers/crypto/chelsio/chtls/chtls_io.c:1140:62: sparse: sparse: generating address of non-lvalue (8)
   drivers/crypto/chelsio/chtls/chtls_io.c:1253:54: sparse: sparse: generating address of non-lvalue (8)
--
   drivers/target/iscsi/cxgbit/cxgbit_target.c:1408:17: sparse: sparse: no member 'size' in struct skb_frag_struct
   drivers/target/iscsi/cxgbit/cxgbit_target.c:1453:45: sparse: sparse: no member 'size' in struct skb_frag_struct
   drivers/target/iscsi/cxgbit/cxgbit_target.c:1473:54: sparse: sparse: no member 'size' in struct skb_frag_struct
>> drivers/target/iscsi/cxgbit/cxgbit_target.c:1453:45: sparse: sparse: unknown expression (8 46)
   drivers/target/iscsi/cxgbit/cxgbit_target.c:1473:54: sparse: sparse: unknown expression (8 46)

vim +1140 drivers/crypto/chelsio/chtls/chtls_io.c

3b8305f5 Atul Gupta 2018-05-27   986  
36bedb3f Atul Gupta 2018-03-31   987  int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
36bedb3f Atul Gupta 2018-03-31   988  {
36bedb3f Atul Gupta 2018-03-31   989  	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
36bedb3f Atul Gupta 2018-03-31   990  	struct chtls_dev *cdev = csk->cdev;
36bedb3f Atul Gupta 2018-03-31   991  	struct tcp_sock *tp = tcp_sk(sk);
36bedb3f Atul Gupta 2018-03-31   992  	struct sk_buff *skb;
36bedb3f Atul Gupta 2018-03-31   993  	int mss, flags, err;
36bedb3f Atul Gupta 2018-03-31   994  	int recordsz = 0;
36bedb3f Atul Gupta 2018-03-31   995  	int copied = 0;
36bedb3f Atul Gupta 2018-03-31   996  	long timeo;
36bedb3f Atul Gupta 2018-03-31   997  
36bedb3f Atul Gupta 2018-03-31   998  	lock_sock(sk);
36bedb3f Atul Gupta 2018-03-31   999  	flags = msg->msg_flags;
36bedb3f Atul Gupta 2018-03-31  1000  	timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
36bedb3f Atul Gupta 2018-03-31  1001  
36bedb3f Atul Gupta 2018-03-31  1002  	if (!sk_in_state(sk, TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)) {
36bedb3f Atul Gupta 2018-03-31  1003  		err = sk_stream_wait_connect(sk, &timeo);
36bedb3f Atul Gupta 2018-03-31  1004  		if (err)
36bedb3f Atul Gupta 2018-03-31  1005  			goto out_err;
36bedb3f Atul Gupta 2018-03-31  1006  	}
36bedb3f Atul Gupta 2018-03-31  1007  
36bedb3f Atul Gupta 2018-03-31  1008  	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
36bedb3f Atul Gupta 2018-03-31  1009  	err = -EPIPE;
36bedb3f Atul Gupta 2018-03-31  1010  	if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN))
36bedb3f Atul Gupta 2018-03-31  1011  		goto out_err;
36bedb3f Atul Gupta 2018-03-31  1012  
36bedb3f Atul Gupta 2018-03-31  1013  	mss = csk->mss;
36bedb3f Atul Gupta 2018-03-31  1014  	csk_set_flag(csk, CSK_TX_MORE_DATA);
36bedb3f Atul Gupta 2018-03-31  1015  
36bedb3f Atul Gupta 2018-03-31  1016  	while (msg_data_left(msg)) {
36bedb3f Atul Gupta 2018-03-31  1017  		int copy = 0;
36bedb3f Atul Gupta 2018-03-31  1018  
36bedb3f Atul Gupta 2018-03-31  1019  		skb = skb_peek_tail(&csk->txq);
36bedb3f Atul Gupta 2018-03-31  1020  		if (skb) {
36bedb3f Atul Gupta 2018-03-31  1021  			copy = mss - skb->len;
36bedb3f Atul Gupta 2018-03-31  1022  			skb->ip_summed = CHECKSUM_UNNECESSARY;
36bedb3f Atul Gupta 2018-03-31  1023  		}
3b8305f5 Atul Gupta 2018-05-27  1024  		if (!csk_mem_free(cdev, sk))
3b8305f5 Atul Gupta 2018-05-27  1025  			goto wait_for_sndbuf;
36bedb3f Atul Gupta 2018-03-31  1026  
36bedb3f Atul Gupta 2018-03-31  1027  		if (is_tls_tx(csk) && !csk->tlshws.txleft) {
36bedb3f Atul Gupta 2018-03-31  1028  			struct tls_hdr hdr;
36bedb3f Atul Gupta 2018-03-31  1029  
36bedb3f Atul Gupta 2018-03-31  1030  			recordsz = tls_header_read(&hdr, &msg->msg_iter);
36bedb3f Atul Gupta 2018-03-31  1031  			size -= TLS_HEADER_LENGTH;
848dd1c1 Atul Gupta 2018-12-11  1032  			copied += TLS_HEADER_LENGTH;
36bedb3f Atul Gupta 2018-03-31  1033  			csk->tlshws.txleft = recordsz;
36bedb3f Atul Gupta 2018-03-31  1034  			csk->tlshws.type = hdr.type;
36bedb3f Atul Gupta 2018-03-31  1035  			if (skb)
36bedb3f Atul Gupta 2018-03-31  1036  				ULP_SKB_CB(skb)->ulp.tls.type = hdr.type;
36bedb3f Atul Gupta 2018-03-31  1037  		}
36bedb3f Atul Gupta 2018-03-31  1038  
36bedb3f Atul Gupta 2018-03-31  1039  		if (!skb || (ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NO_APPEND) ||
36bedb3f Atul Gupta 2018-03-31  1040  		    copy <= 0) {
36bedb3f Atul Gupta 2018-03-31  1041  new_buf:
36bedb3f Atul Gupta 2018-03-31  1042  			if (skb) {
36bedb3f Atul Gupta 2018-03-31  1043  				tx_skb_finalize(skb);
36bedb3f Atul Gupta 2018-03-31  1044  				push_frames_if_head(sk);
36bedb3f Atul Gupta 2018-03-31  1045  			}
36bedb3f Atul Gupta 2018-03-31  1046  
36bedb3f Atul Gupta 2018-03-31  1047  			if (is_tls_tx(csk)) {
36bedb3f Atul Gupta 2018-03-31  1048  				skb = get_record_skb(sk,
36bedb3f Atul Gupta 2018-03-31  1049  						     select_size(sk,
36bedb3f Atul Gupta 2018-03-31  1050  								 recordsz,
36bedb3f Atul Gupta 2018-03-31  1051  								 flags,
36bedb3f Atul Gupta 2018-03-31  1052  								 TX_TLSHDR_LEN),
36bedb3f Atul Gupta 2018-03-31  1053  								 false);
36bedb3f Atul Gupta 2018-03-31  1054  			} else {
36bedb3f Atul Gupta 2018-03-31  1055  				skb = get_tx_skb(sk,
36bedb3f Atul Gupta 2018-03-31  1056  						 select_size(sk, size, flags,
36bedb3f Atul Gupta 2018-03-31  1057  							     TX_HEADER_LEN));
36bedb3f Atul Gupta 2018-03-31  1058  			}
36bedb3f Atul Gupta 2018-03-31  1059  			if (unlikely(!skb))
36bedb3f Atul Gupta 2018-03-31  1060  				goto wait_for_memory;
36bedb3f Atul Gupta 2018-03-31  1061  
36bedb3f Atul Gupta 2018-03-31  1062  			skb->ip_summed = CHECKSUM_UNNECESSARY;
36bedb3f Atul Gupta 2018-03-31  1063  			copy = mss;
36bedb3f Atul Gupta 2018-03-31  1064  		}
36bedb3f Atul Gupta 2018-03-31  1065  		if (copy > size)
36bedb3f Atul Gupta 2018-03-31  1066  			copy = size;
36bedb3f Atul Gupta 2018-03-31  1067  
36bedb3f Atul Gupta 2018-03-31  1068  		if (skb_tailroom(skb) > 0) {
36bedb3f Atul Gupta 2018-03-31  1069  			copy = min(copy, skb_tailroom(skb));
36bedb3f Atul Gupta 2018-03-31  1070  			if (is_tls_tx(csk))
36bedb3f Atul Gupta 2018-03-31  1071  				copy = min_t(int, copy, csk->tlshws.txleft);
36bedb3f Atul Gupta 2018-03-31  1072  			err = skb_add_data_nocache(sk, skb,
36bedb3f Atul Gupta 2018-03-31  1073  						   &msg->msg_iter, copy);
36bedb3f Atul Gupta 2018-03-31  1074  			if (err)
36bedb3f Atul Gupta 2018-03-31  1075  				goto do_fault;
36bedb3f Atul Gupta 2018-03-31  1076  		} else {
36bedb3f Atul Gupta 2018-03-31  1077  			int i = skb_shinfo(skb)->nr_frags;
36bedb3f Atul Gupta 2018-03-31  1078  			struct page *page = TCP_PAGE(sk);
36bedb3f Atul Gupta 2018-03-31  1079  			int pg_size = PAGE_SIZE;
36bedb3f Atul Gupta 2018-03-31  1080  			int off = TCP_OFF(sk);
36bedb3f Atul Gupta 2018-03-31  1081  			bool merge;
36bedb3f Atul Gupta 2018-03-31  1082  
848dd1c1 Atul Gupta 2018-12-11  1083  			if (page)
1dfe57aa Atul Gupta 2018-05-27  1084  				pg_size <<= compound_order(page);
36bedb3f Atul Gupta 2018-03-31  1085  			if (off < pg_size &&
36bedb3f Atul Gupta 2018-03-31  1086  			    skb_can_coalesce(skb, i, page, off)) {
36bedb3f Atul Gupta 2018-03-31  1087  				merge = 1;
36bedb3f Atul Gupta 2018-03-31  1088  				goto copy;
36bedb3f Atul Gupta 2018-03-31  1089  			}
36bedb3f Atul Gupta 2018-03-31  1090  			merge = 0;
36bedb3f Atul Gupta 2018-03-31  1091  			if (i == (is_tls_tx(csk) ? (MAX_SKB_FRAGS - 1) :
36bedb3f Atul Gupta 2018-03-31  1092  			    MAX_SKB_FRAGS))
36bedb3f Atul Gupta 2018-03-31  1093  				goto new_buf;
36bedb3f Atul Gupta 2018-03-31  1094  
36bedb3f Atul Gupta 2018-03-31  1095  			if (page && off == pg_size) {
36bedb3f Atul Gupta 2018-03-31  1096  				put_page(page);
36bedb3f Atul Gupta 2018-03-31  1097  				TCP_PAGE(sk) = page = NULL;
36bedb3f Atul Gupta 2018-03-31  1098  				pg_size = PAGE_SIZE;
36bedb3f Atul Gupta 2018-03-31  1099  			}
36bedb3f Atul Gupta 2018-03-31  1100  
36bedb3f Atul Gupta 2018-03-31  1101  			if (!page) {
36bedb3f Atul Gupta 2018-03-31  1102  				gfp_t gfp = sk->sk_allocation;
36bedb3f Atul Gupta 2018-03-31  1103  				int order = cdev->send_page_order;
36bedb3f Atul Gupta 2018-03-31  1104  
36bedb3f Atul Gupta 2018-03-31  1105  				if (order) {
36bedb3f Atul Gupta 2018-03-31  1106  					page = alloc_pages(gfp | __GFP_COMP |
36bedb3f Atul Gupta 2018-03-31  1107  							   __GFP_NOWARN |
36bedb3f Atul Gupta 2018-03-31  1108  							   __GFP_NORETRY,
36bedb3f Atul Gupta 2018-03-31  1109  							   order);
36bedb3f Atul Gupta 2018-03-31  1110  					if (page)
36bedb3f Atul Gupta 2018-03-31  1111  						pg_size <<=
36bedb3f Atul Gupta 2018-03-31  1112  							compound_order(page);
36bedb3f Atul Gupta 2018-03-31  1113  				}
36bedb3f Atul Gupta 2018-03-31  1114  				if (!page) {
36bedb3f Atul Gupta 2018-03-31  1115  					page = alloc_page(gfp);
36bedb3f Atul Gupta 2018-03-31  1116  					pg_size = PAGE_SIZE;
36bedb3f Atul Gupta 2018-03-31  1117  				}
36bedb3f Atul Gupta 2018-03-31  1118  				if (!page)
36bedb3f Atul Gupta 2018-03-31  1119  					goto wait_for_memory;
36bedb3f Atul Gupta 2018-03-31  1120  				off = 0;
36bedb3f Atul Gupta 2018-03-31  1121  			}
36bedb3f Atul Gupta 2018-03-31  1122  copy:
36bedb3f Atul Gupta 2018-03-31  1123  			if (copy > pg_size - off)
36bedb3f Atul Gupta 2018-03-31  1124  				copy = pg_size - off;
36bedb3f Atul Gupta 2018-03-31  1125  			if (is_tls_tx(csk))
36bedb3f Atul Gupta 2018-03-31  1126  				copy = min_t(int, copy, csk->tlshws.txleft);
36bedb3f Atul Gupta 2018-03-31  1127  
36bedb3f Atul Gupta 2018-03-31  1128  			err = chtls_skb_copy_to_page_nocache(sk, &msg->msg_iter,
36bedb3f Atul Gupta 2018-03-31  1129  							     skb, page,
36bedb3f Atul Gupta 2018-03-31  1130  							     off, copy);
36bedb3f Atul Gupta 2018-03-31  1131  			if (unlikely(err)) {
36bedb3f Atul Gupta 2018-03-31  1132  				if (!TCP_PAGE(sk)) {
36bedb3f Atul Gupta 2018-03-31  1133  					TCP_PAGE(sk) = page;
36bedb3f Atul Gupta 2018-03-31  1134  					TCP_OFF(sk) = 0;
36bedb3f Atul Gupta 2018-03-31  1135  				}
36bedb3f Atul Gupta 2018-03-31  1136  				goto do_fault;
36bedb3f Atul Gupta 2018-03-31  1137  			}
36bedb3f Atul Gupta 2018-03-31  1138  			/* Update the skb. */
36bedb3f Atul Gupta 2018-03-31  1139  			if (merge) {
36bedb3f Atul Gupta 2018-03-31 @1140  				skb_shinfo(skb)->frags[i - 1].size += copy;
36bedb3f Atul Gupta 2018-03-31  1141  			} else {
36bedb3f Atul Gupta 2018-03-31  1142  				skb_fill_page_desc(skb, i, page, off, copy);
36bedb3f Atul Gupta 2018-03-31  1143  				if (off + copy < pg_size) {
36bedb3f Atul Gupta 2018-03-31  1144  					/* space left keep page */
36bedb3f Atul Gupta 2018-03-31  1145  					get_page(page);
36bedb3f Atul Gupta 2018-03-31  1146  					TCP_PAGE(sk) = page;
36bedb3f Atul Gupta 2018-03-31  1147  				} else {
36bedb3f Atul Gupta 2018-03-31  1148  					TCP_PAGE(sk) = NULL;
36bedb3f Atul Gupta 2018-03-31  1149  				}
36bedb3f Atul Gupta 2018-03-31  1150  			}
36bedb3f Atul Gupta 2018-03-31  1151  			TCP_OFF(sk) = off + copy;
36bedb3f Atul Gupta 2018-03-31  1152  		}
36bedb3f Atul Gupta 2018-03-31  1153  		if (unlikely(skb->len == mss))
36bedb3f Atul Gupta 2018-03-31  1154  			tx_skb_finalize(skb);
36bedb3f Atul Gupta 2018-03-31  1155  		tp->write_seq += copy;
36bedb3f Atul Gupta 2018-03-31  1156  		copied += copy;
36bedb3f Atul Gupta 2018-03-31  1157  		size -= copy;
36bedb3f Atul Gupta 2018-03-31  1158  
36bedb3f Atul Gupta 2018-03-31  1159  		if (is_tls_tx(csk))
36bedb3f Atul Gupta 2018-03-31  1160  			csk->tlshws.txleft -= copy;
36bedb3f Atul Gupta 2018-03-31  1161  
36bedb3f Atul Gupta 2018-03-31  1162  		if (corked(tp, flags) &&
36bedb3f Atul Gupta 2018-03-31  1163  		    (sk_stream_wspace(sk) < sk_stream_min_wspace(sk)))
36bedb3f Atul Gupta 2018-03-31  1164  			ULP_SKB_CB(skb)->flags |= ULPCB_FLAG_NO_APPEND;
36bedb3f Atul Gupta 2018-03-31  1165  
36bedb3f Atul Gupta 2018-03-31  1166  		if (size == 0)
36bedb3f Atul Gupta 2018-03-31  1167  			goto out;
36bedb3f Atul Gupta 2018-03-31  1168  
36bedb3f Atul Gupta 2018-03-31  1169  		if (ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NO_APPEND)
36bedb3f Atul Gupta 2018-03-31  1170  			push_frames_if_head(sk);
36bedb3f Atul Gupta 2018-03-31  1171  		continue;
3b8305f5 Atul Gupta 2018-05-27  1172  wait_for_sndbuf:
3b8305f5 Atul Gupta 2018-05-27  1173  		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
36bedb3f Atul Gupta 2018-03-31  1174  wait_for_memory:
3b8305f5 Atul Gupta 2018-05-27  1175  		err = csk_wait_memory(cdev, sk, &timeo);
36bedb3f Atul Gupta 2018-03-31  1176  		if (err)
36bedb3f Atul Gupta 2018-03-31  1177  			goto do_error;
36bedb3f Atul Gupta 2018-03-31  1178  	}
36bedb3f Atul Gupta 2018-03-31  1179  out:
36bedb3f Atul Gupta 2018-03-31  1180  	csk_reset_flag(csk, CSK_TX_MORE_DATA);
36bedb3f Atul Gupta 2018-03-31  1181  	if (copied)
36bedb3f Atul Gupta 2018-03-31  1182  		chtls_tcp_push(sk, flags);
36bedb3f Atul Gupta 2018-03-31  1183  done:
36bedb3f Atul Gupta 2018-03-31  1184  	release_sock(sk);
848dd1c1 Atul Gupta 2018-12-11  1185  	return copied;
36bedb3f Atul Gupta 2018-03-31  1186  do_fault:
36bedb3f Atul Gupta 2018-03-31  1187  	if (!skb->len) {
36bedb3f Atul Gupta 2018-03-31  1188  		__skb_unlink(skb, &csk->txq);
36bedb3f Atul Gupta 2018-03-31  1189  		sk->sk_wmem_queued -= skb->truesize;
36bedb3f Atul Gupta 2018-03-31  1190  		__kfree_skb(skb);
36bedb3f Atul Gupta 2018-03-31  1191  	}
36bedb3f Atul Gupta 2018-03-31  1192  do_error:
36bedb3f Atul Gupta 2018-03-31  1193  	if (copied)
36bedb3f Atul Gupta 2018-03-31  1194  		goto out;
36bedb3f Atul Gupta 2018-03-31  1195  out_err:
36bedb3f Atul Gupta 2018-03-31  1196  	if (csk_conn_inline(csk))
36bedb3f Atul Gupta 2018-03-31  1197  		csk_reset_flag(csk, CSK_TX_MORE_DATA);
36bedb3f Atul Gupta 2018-03-31  1198  	copied = sk_stream_error(sk, flags, err);
36bedb3f Atul Gupta 2018-03-31  1199  	goto done;
36bedb3f Atul Gupta 2018-03-31  1200  }
36bedb3f Atul Gupta 2018-03-31  1201  

:::::: The code at line 1140 was first introduced by commit
:::::: 36bedb3f2e5b81832b5895363ed3fedb9ff1e8d0 crypto: chtls - Inline TLS record Tx

:::::: TO: Atul Gupta <atul.gupta@chelsio.com>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
